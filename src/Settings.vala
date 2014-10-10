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

public class Settings : Object {
    public struct Creds {
        string username;
        string password;
    }

    private GLib.Settings settings;

    public signal void changed ();

    public Settings () {
        settings = new GLib.Settings ("org.gnome.gistit");
        settings.changed.connect ((key) => {
                settings_changed ();
        });

    }

    public string get_accelerator () {
        return settings.get_string ("hotkey");
    }

    public void set_accelerator (string hotkey) {
        settings.set_string ("hotkey", hotkey);
    }

    public Creds? get_credentials () {
        var cred_str = settings.get_string ("account");

        if (cred_str.length >0) {
            var cred_split = cred_str.split (":");
            var username = (string) Base64.decode (cred_split[0]);
            var password = (string) Base64.decode (cred_split[1]);
            return Creds () {
                username = username,
                password = password
                    };
        } else {
            return null;
        }
    }

    public void set_credentials (string username, string password) {
        var busername = Base64.encode (username.data);
        var bpassword = Base64.encode (password.data);

        var creds_str = "%s:%s".printf (busername, bpassword);

        settings.set_string ("account", creds_str);
    }

    public bool is_anonymous () {
        return settings.get_boolean ("anonymous");
    }

    public void set_anonymous (bool value) {
        settings.set_boolean ("anonymous", value);
    }

    private void settings_changed () {
        changed ();
    }
}