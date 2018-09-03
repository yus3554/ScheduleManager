package schedule.topview;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;

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
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("utf-8");

		HttpSession session = request.getSession(false);

		// sessionから新規アカウント情報を取得
		String userName = (String)session.getAttribute("userName");
		String email = (String)session.getAttribute("email");
		String pass = (String)session.getAttribute("password");

		String view = "";

		// ローカルipを取得して回答ページのリンクに使う
		String ipAddr = "";
		try {
			InetAddress addr = InetAddress.getLocalHost();
			ipAddr = addr.getHostAddress();
		} catch (UnknownHostException e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}

		// 登録者にメールを送信
		String subject = "登録完了";
		String content = "<html><body>スケジュール管理システムへの登録が完了しました。<br><br>"
				+ "<table>" +
				"		<tr><td>名前：</td><td>" + userName + "</td></tr>" +
				"		<tr><td>メールアドレス：</td><td>" + email + "</td></tr>" +
				"		<tr><td>パスワード：</td><td>" + pass + "</td></tr>" +
				"	</table><br><br>"
				+ "<a href=\"http://" + ipAddr + ":8080/ScheduleManager/Login\">ログインはこちら</a><br><br></body></html>";

		// メールアドレスの重複がないか
		if (new UserTable().isEmailSame(email)) {
			new UserTable().insert(userName, email, pass);
			new SendMail().send(subject, content, email);
			// jspを指定
			view = "/WEB-INF/view/auth/signupsubmit.jsp";
		}else {
			view = "/WEB-INF/view/auth/signupfailed.jsp";
		}

		// sessionから新規アカウント情報を削除
		session.removeAttribute("userName");
		session.removeAttribute("email");
		session.removeAttribute("password");

		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);
	}

}
