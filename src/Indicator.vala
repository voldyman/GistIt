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

using AppIndicator;

public class Indicator : Object {
	private const string ICON_NAME = "document-open-symbolic";

	private GistIt app;

	private AppIndicator.Indicator ind;
	private Gtk.Menu ind_menu;

	private Gtk.MenuItem from_clipboard;
	private Gtk.MenuItem from_selection;
	private Gtk.MenuItem settings_item;
	private Gtk.MenuItem quit_item;
	

	public signal void clipboard_text ();
	public signal void selected_text ();
	public signal void settings ();
	public signal void quit ();

	public Indicator (GistIt app) {
		this.app = app;

		this.ind = new AppIndicator.Indicator (_("Gist It"), ICON_NAME,
											   IndicatorCategory.APPLICATION_STATUS);

		ind.set_status (IndicatorStatus.ACTIVE);

		setup_menu ();
		connect_signals ();
	}

	private void setup_menu () {
		ind_menu = new Gtk.Menu ();

		from_clipboard = new Gtk.MenuItem.with_label (_("Create a gist for clipboard text"));
		from_selection = new Gtk.MenuItem.with_label (_("Create a gist for highlighted text"));

		settings_item = new Gtk.MenuItem.with_label (_("Settings"));
		quit_item = new Gtk.MenuItem.with_label (_("Quit"));
		
		ind_menu.append (from_clipboard);
		ind_menu.append (from_selection);
		ind_menu.append (new Gtk.SeparatorMenuItem ());
		ind_menu.append (settings_item);
		ind_menu.append (quit_item);
		ind_menu.show_all ();

		ind.set_menu (ind_menu);
	}

	private void connect_signals () {
		from_clipboard.activate.connect (() => {
				clipboard_text ();
			});
		from_selection.activate.connect (() => {
				selected_text ();
			});
		
		settings_item.activate.connect (() => {
				settings ();
			});
		quit_item.activate.connect (() => {
				quit ();
			});
		
	}
}