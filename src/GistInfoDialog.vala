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

public class GistInfoDialog : Gtk.Window {

	private Gtk.Entry filename;
	private Gtk.TextView description;
	private Gtk.Switch is_public;
	private Gtk.Button ok;
	private Gtk.Button cancel;
	
	public signal void got_info (GistInfoDialog instance);

    public GistInfoDialog () {
        setup_ui ();
		connect_signals ();
    }

    private void setup_ui () {
        this.title = "Gist It";
        this.window_position = Gtk.WindowPosition.CENTER;

        this.set_default_size (500, 500);
        this.resizable = false;
		this.set_keep_above (true);
		this.skip_taskbar_hint = true;
		
		filename = new Gtk.Entry ();
		description = new Gtk.TextView ();
		is_public = new Gtk.Switch ();
		ok = new Gtk.Button.with_label (_("Post"));
		cancel = new Gtk.Button.with_label (_("Cancel"));

		is_public.active = true;
		
		var grid = new Gtk.Grid ();
		grid.set_orientation (Gtk.Orientation.VERTICAL);
		grid.halign = Gtk.Align.CENTER;
		grid.valign = Gtk.Align.CENTER;
		grid.margin = 10;
		grid.row_spacing = 12;
		grid.column_spacing = 5;

		var button_grid = new Gtk.Grid ();
		button_grid.set_orientation (Gtk.Orientation.HORIZONTAL);
		button_grid.halign = Gtk.Align.END;
		button_grid.valign = Gtk.Align.CENTER;
		button_grid.column_spacing = 5;

		button_grid.attach (ok, 0, 0, 1, 1);
		button_grid.attach (cancel, 1, 0, 1, 1);
		
		var scrolled = new Gtk.ScrolledWindow (null, null);
		scrolled.add (description);

		
		grid.attach (new Gtk.Label (_("File name")), 0, 0, 1, 1);
		grid.attach (filename, 1, 0, 1, 1);

		grid.attach (new Gtk.Label (_("Description")), 0, 1, 1, 1);
		grid.attach (scrolled, 1, 1, 1, 1);

		grid.attach (new Gtk.Label (_("Public")), 0, 2, 1, 1);
		grid.attach (is_public, 1, 2, 1, 1);
					 
		grid.attach (button_grid, 1, 3, 1, 1);
		
		this.add (grid);
    }

	private void connect_signals () {
		ok.clicked.connect (ok_pressed);
		cancel.clicked.connect (cancel_pressed);
	}

	private void ok_pressed () {
		got_info (this);
		close ();
	}

	private void cancel_pressed () {
		close ();
	}

	public void run () {
		this.show_all ();
		this.present ();
		set_focus (null);
	}

	public string get_filename () {
		return filename.get_text ();
	}

	public string get_description () {
		return description.buffer.text;
	}

	public bool get_public () {
		return is_public.active;
	}
}