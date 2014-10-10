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

public class KeyBindingManager : Object {
    private Gdk.Window win;
    private unowned X.Display display;
    private string current_accelerator = "";

    public signal void key_pressed ();

    public KeyBindingManager () {

        win = Gdk.get_default_root_window ();

        win.add_filter(filter_func);

        display = Gdk.X11.get_default_xdisplay ();
    }

    public void bind (string accelerator) {
        current_accelerator = accelerator;

        uint key_sym;
        Gdk.ModifierType mask;

        Gtk.accelerator_parse (accelerator, out key_sym, out mask);

        display.grab_key (display.keysym_to_keycode(key_sym),
                          mask,Gdk.X11.get_default_root_xwindow(),
                          false, X.GrabMode.Async, X.GrabMode.Async);

    }

    public void unbind () {
        if (current_accelerator != "") {
            uint key_sym;
            Gdk.ModifierType mask;

            Gtk.accelerator_parse (current_accelerator, out key_sym, out mask);

            display.ungrab_key (display.keysym_to_keycode(key_sym),
                                mask, Gdk.X11.get_default_root_xwindow());

            current_accelerator = "";
        }
    }

    Gdk.FilterReturn filter_func(Gdk.XEvent gdk_xevent, Gdk.Event ev) {
        Gdk.FilterReturn filter_return = Gdk.FilterReturn.CONTINUE;

        X.Event *xevent = (X.Event *) gdk_xevent;
        if (xevent->type == X.EventType.KeyPress) {
            key_pressed ();
        }
        return filter_return;
    }
}