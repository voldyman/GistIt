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

public class ClipboardManager : Object {

	public static string get_selected_text () {
		var clipboard = Gtk.Clipboard.get_for_display (Gdk.Display.get_default (),
													   Gdk.SELECTION_PRIMARY);
		string text = clipboard.wait_for_text ();
		return text;
	}

	public static string get_clipboard_text () {
		var clipboard = Gtk.Clipboard.get_for_display (Gdk.Display.get_default (),
													   Gdk.SELECTION_CLIPBOARD);
		string text = clipboard.wait_for_text ();
		return text;
	}
	public static void set_text (string text) {
		var clipboard = Gtk.Clipboard.get_for_display (Gdk.Display.get_default (),
													   Gdk.SELECTION_CLIPBOARD);
		clipboard.set_text (text, text.length);
	}
}