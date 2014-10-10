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

public class ConfigDialog : Gtk.Window {

    private Gtk.Switch is_anonymous;
    private Gtk.Entry username_entry;
    private Gtk.Entry password_entry;

    private Gtk.Button ok_button;
    private Gtk.Button cancel_button;

    public signal void config_changed (ConfigDialog instance);

    public ConfigDialog () {
        setup_ui ();
        connect_signals ();
    }

    public void run () {
        this.show_all ();
        this.present ();
        set_focus (null);
    }

    private void setup_ui () {
        this.title = "Gist It Config";
        this.window_position = Gtk.WindowPosition.CENTER;

        this.set_default_size (500, 500);
        this.resizable = false;
        this.set_keep_above (true);

        is_anonymous = new Gtk.Switch ();
        username_entry = new Gtk.Entry ();
        password_entry = new Gtk.Entry ();
        password_entry.visibility = false;

        ok_button = new Gtk.Button.with_label (_("Save"));
        cancel_button = new Gtk.Button.with_label (_("Cancel"));

        var button_grid = new Gtk.Grid ();
        button_grid.set_orientation (Gtk.Orientation.HORIZONTAL);
		button_grid.halign = Gtk.Align.END;
		button_grid.valign = Gtk.Align.CENTER;
		button_grid.column_spacing = 5;

        button_grid.attach (ok_button, 0, 0, 1, 1);
        button_grid.attach (cancel_button, 1, 0, 1, 1);

        var grid = new Gtk.Grid ();

        grid.set_orientation (Gtk.Orientation.VERTICAL);
		grid.halign = Gtk.Align.CENTER;
		grid.valign = Gtk.Align.CENTER;
		grid.margin = 10;
		grid.row_spacing = 12;
		grid.column_spacing = 5;

        grid.attach (new Gtk.Label (_("Anonymous")), 0, 0, 1, 1);
        grid.attach (is_anonymous, 1, 0, 1, 1);

        grid.attach (new Gtk.Label (_("Username")), 0, 1, 1, 1);
        grid.attach (username_entry, 1, 1, 1, 1);

        grid.attach (new Gtk.Label (_("Password")), 0, 2, 1, 1);
        grid.attach (password_entry, 1, 2, 1, 1);

        grid.attach (button_grid, 1, 3, 1, 1);

        this.add (grid);
    }

    private void connect_signals () {
        is_anonymous.notify["active"].connect (anonymous_activate);
        
        ok_button.clicked.connect (ok_pressed);
        cancel_button.clicked.connect (cancel_pressed);
    }

    private void anonymous_activate () {
        bool value = is_anonymous.active;

        if (value) {
            username_entry.sensitive = false;
            password_entry.sensitive = false;
        } else {
            username_entry.sensitive = true;
            password_entry.sensitive = true;
        }
    }

    private void ok_pressed () {
        config_changed (this);
        close();
    }
    
    private void cancel_pressed () {
        close ();
    }

    public void set_username (string username) {
        username_entry.set_text (username);
    }
    
    public void set_anonymous (bool anon) {
        is_anonymous.active = anon;
    }

    public void set_password (string password) {
        password_entry.set_text (password);
    }

    public string get_username () {
        return username_entry.get_text ();
    }

    public string get_password () {
        return password_entry.get_text ();
    }

    public bool get_anonymous () {
        return is_anonymous.active;
    }
}