import stdlib.web.client
import stdlib.web.mail
import stdlib.crypto
import stdlib.tools.markdown
import stdlib.io.file
import stdlib.system
import stdlib.upload

#<Ifstatic:DEV>
_ = Log.warning("Warning", "Dev mode ON!")
#<Else>
#<End>

do_404 = Resource.default_error_page({wrong_address})

dispatcher = {
    // tts = Text.to_string
    resources = @static_include_directory("resources")
    parser {

    case "/resources/" path=(.*) :
        StringMap.get("resources/{path}", resources) ? do_404

    case _url=(.*) : Pages.home()

    }
}

//initialization

_ = Server.start(
    {Server.http with name : "http"},
    {custom : dispatcher}
)
