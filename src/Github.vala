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

public class Github : Object {

    private Soup.Session session;
    private string username;
    private string password;
    private bool anonymous;
    
    public Github () {
        session = new Soup.Session ();
    }

    public void set_anonymous (bool value=true) {
        this.anonymous = value;
    }
    
    public void set_credentials (string username, string password) {
        this.username = username;
        this.password = password;
        this.anonymous = false;
    }

    public string create_gist (string filename, string content,string description, bool is_public) throws Error {
        string json = gist_json (filename, content, is_public, description);
        string url = "";

        url = post_gist (json, this.anonymous);

        return url;
    } 
    
    private string post_gist (string gist_json, bool is_anonymous) throws Error {
        var session = new Soup.Session ();
        var headers = new Soup.MessageHeaders (Soup.MessageHeadersType.REQUEST);
        var msg = new Soup.Message ("POST", "https://api.github.com/gists");
        var body = new Soup.MessageBody ();
	
        body.append_take (gist_json.data);


        if (!is_anonymous) {
            string auth_val = Base64.encode ("%s:%s".printf (username, password).data);
            headers.append ("Authorization", "Basic %s".printf (auth_val));
        }
        
        headers.append ("User-Agent", "ninja-turtle");

        msg.request_headers = headers;
        msg.request_body = body;
	
        session.send_message (msg);

        if (msg.status_code != 201) {
            if (msg.status_code == 401) {
                throw new Error (Quark.from_string ("gistit"),
                                 -1, _("Invalid Credentails"));
            }
            print ("Error code: %u\n", msg.status_code);
            throw new Error (Quark.from_string ("gistit"),
                             -1, "Got error from github");
        }

        return parse_json_response ((string) msg.response_body.data);
    }
    
    private string parse_json_response (string data) throws Error {
        Json.Parser parser = new Json.Parser ();
        Json.Node? root;

        parser.load_from_data (data);

        root = parser.get_root ();

        return root.get_object ().get_string_member ("html_url");
    }

    private string gist_json (string filename, string content, bool is_public, string description) {
        var generator = new Json.Generator ();

        var builder = new Json.Builder ();
        builder.begin_object ();
    
        builder.set_member_name ("description")
            .add_string_value (description);

        builder.set_member_name ("public")
            .add_boolean_value (is_public);

        builder.set_member_name ("files")
            .begin_object ()
                .set_member_name (filename)
                .begin_object ()
                    .set_member_name ("content")
                    .add_string_value (content)
                .end_object ()
            .end_object ();
    
        builder.end_object ();
    
        generator.set_root (builder.get_root ());
    
        return generator.to_data (null);
    }
}