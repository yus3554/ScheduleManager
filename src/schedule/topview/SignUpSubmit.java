package schedule.topview;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import schedule.model.SendMail;
import schedule.model.UserTable;

/**
 * Servlet implementation class SignUpSubmit
 */
@WebServlet("/SignUpSubmit")
public class SignUpSubmit extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public SignUpSubmit() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");

		HttpSession session = request.getSession(false);

		// sessionから新規アカウント情報を取得
		String userName = (String)session.getAttribute("userNameSignUp");
		String email = (String)session.getAttribute("emailSignUp");
		String pass = (String)session.getAttribute("passwordSignUp");

		// 回答ページのリンクに使うポート番号などを含むアドレス
		String address = "";

		String osName = System.getProperty("os.name").toLowerCase();
		////////////////////////////////////////////////////////////////
		// 自分のパソコンだと、ipアドレスは変更されるので、こっち
		if(osName.startsWith("mac")) {
			String ipAddr = "";
			System.setProperty("java.net.preferIPv4Stack" , "true");
			try {
				InetAddress addr = InetAddress.getLocalHost();
				ipAddr = addr.getHostAddress();
			} catch (UnknownHostException e1) {
				e1.printStackTrace();
			}
			address = "https://" + ipAddr + ":8443";
		/////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////
		// 研究室のサーバーでは、ipアドレスは固定なのでこっち
		} else if(osName.startsWith("linux")) {
			address = "http://192.168.132.118:8081";
		}
		/////////////////////////////////////////////////////////////////

		// 登録者にメールを送信
		String subject = "登録完了";
		String content = "<html><body>スケジュール管理システムへの登録が完了しました。<br><br>"
				+ "<table>" +
				"		<tr><td>名前：</td><td>" + userName + "</td></tr>" +
				"		<tr><td>メールアドレス：</td><td>" + email + "</td></tr>" +
				"		<tr><td>パスワード：</td><td>**********</td></tr>" +
				"	</table><br><br>"
				+ "<a href=\"" + address + "/ScheduleManager/TopPage\">ログインはこちら</a><br><br></body></html>";

		// メールアドレスの重複がないか
		String view = "";
		if (new UserTable().isEmailSame(email)) {
			new UserTable().insert(userName, email, pass);
			//new SendMail().send(subject, content, email);
			// jspを指定
			view = "/WEB-INF/view/auth/signupsubmit.jsp";
		}else {
			view = "/WEB-INF/view/auth/signupfailed.jsp";
		}

		// sessionから新規アカウント情報を削除
		session.removeAttribute("userNameSignUp");
		session.removeAttribute("emailSignUp");
		session.removeAttribute("passwordSignUp");
		session.removeAttribute("passwordHiddenSignUp");

		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);
	}

}
