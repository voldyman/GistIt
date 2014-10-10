/*-
 * Copyright (c) 2013-2014 Akshay Shekher
 *
 * This software is licensed under the GNU General Public License
 * (version 3 or later). See the COPYING file in this distribution.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this software; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authored by: Akshay Shekher <voldyman666@gmail.com>
 */

public class GistIt : Gtk.Application {
	private enum GistFrom {
		CLIPBOARD,
		SELECTION
	}

	private MainLoop loop;

	public Indicator app_indicator;
	public KeyBindingManager key_manager;
    public Settings settings;
    public Github api;
	
    public GistIt () {
		Object (application_id: "com.voldy.gistit",
				flags: ApplicationFlags.FLAGS_NONE);

    }

	public override void startup () {
		base.startup ();
		
		Notify.init ("Gist It");

		print ("Started up\n");
		app_indicator = new Indicator (this);
		key_manager = new KeyBindingManager ();
        settings = new Settings ();
        api = new Github ();

        settings.changed.connect (settings_changed);
        settings_changed ();

		app_indicator.clipboard_text.connect (() => {
				gist_it (GistFrom.CLIPBOARD);
			});

		app_indicator.selected_text.connect (() => {
				gist_it (GistFrom.SELECTION);
			});

        app_indicator.settings.connect (settings_activated);

		app_indicator.quit.connect (quit);
		

        var hotkey = settings.get_accelerator ();
        if (hotkey.length == 0) {
            key_manager.bind ("<Control><Shift>c");
        } else {
            key_manager.bind (hotkey);
        }

		key_manager.key_pressed.connect (key_pressed);
		
		loop = new MainLoop ();
		loop.run ();
	}

    private void settings_activated () {
        var settings_dialog = new ConfigDialog ();

        if (settings.is_anonymous ()) {
            settings_dialog.set_anonymous (true);
        } else {
            var creds = settings.get_credentials ();
            settings_dialog.set_username (creds.username);
            settings_dialog.set_password (creds.password);
        }
        
        settings_dialog.set_application (this);
        
        settings_dialog.config_changed.connect ((instance) => {
                settings.set_anonymous (instance.get_anonymous ());
                settings.set_credentials (instance.get_username (),
                                          instance.get_password ());
            });
        settings_dialog.run ();
    }

    private void settings_changed () {
        key_manager.unbind ();

        var hotkey = settings.get_accelerator ();
        if (hotkey.length == 0) {
            key_manager.bind ("<Control><Shift>c");
        } else {
            key_manager.bind (hotkey);
        }

        if (settings.is_anonymous ()) {
            api.set_anonymous (true);
        } else {
            var creds = settings.get_credentials ();
            api.set_credentials (creds.username, creds.password);
        }
    }

	private void key_pressed () {
		gist_it (GistFrom.SELECTION);
	}

	private void gist_it (GistFrom from) {
		string text = "";
		switch (from) {
		case GistFrom.CLIPBOARD:
			text = ClipboardManager.get_clipboard_text ();
			break;
		case GistFrom.SELECTION:
			text = ClipboardManager.get_selected_text ();
			break;
		}
		if (text == null || text == "") {
			return;
		}
		
		var dialog = new GistInfoDialog ();
		dialog.set_application (this);
		dialog.got_info.connect ( (instance) => {
                ThreadFunc<void*> run = () => {
                    try {
                        var url = api.create_gist (instance.get_filename (), text,
                                                   instance.get_description (),
                                                   instance.get_public ());
                        Idle.add (() => {
                                notification (_("Gist created, the url is in your clipboard"));
                                ClipboardManager.set_text (url);
                                return false;
                            });
                    } catch (Error e) {
                        print ("Error: %s\n", e.message);
                        string error_message = "\n%s".printf (e.message);
                        Idle.add (() => {
                                notification (_("Unable to create gist") + error_message, true);
                                return false;
                            });
                    }
                    return null;
                };
                new Thread<void*> ("Gist Post", run);
			});
		dialog.show_all ();
	}

	private void notification (string text, bool error=false) {
		string summary = "GistIt";
        string icon = "";
        if (error) {
            icon = "dialog-error";
        } else {
             icon = "dialog-information";
        }
        try {
            Notify.Notification notification = new Notify.Notification (summary, text, icon);
            notification.show ();
        } catch (Error e) {
            print ("Error: %s", e.message);
        }
	}

    private new void quit () {
        loop.quit ();
        base.quit ();
    }
}

int main (string[] args) {
	GistIt app = new GistIt ();

	return app.run (args);
}