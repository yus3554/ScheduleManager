package schedule.topview;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//import org.apache.tomcat.jdbc.pool.DataSource;
import javax.sql.DataSource;

/**
 * サーブレット実行クラス LoginCheck
 * ログインチェック
 * @author yusuke
 */
@WebServlet("/LoginCheck")
public class LoginCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginCheck() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		String email = (String) request.getParameter("email");
		String pass = (String) request.getParameter("password");

		// sessionを取得
		HttpSession session = request.getSession(false);

		// authUserでアカウントのユーザネームを取得
		String check = authUser(email, pass);

		if (session == null){
			/* セッションが開始されずにここへ来た場合は無条件でエラー表示 */
			response.sendRedirect("./LoginFailed");
		} else {
			// checkにユーザーネームが入っているか
			if (check != null) {
				/* 認証済みにセット */
				session.setAttribute("login", "OK");

				/* ユーザーページに飛ばす */
				session.setAttribute("userName", check);
				session.setAttribute("email", email);
				response.sendRedirect("./UserPage");
			} else {
				/* 認証に失敗したら、ログイン画面に戻す */
				session.setAttribute("status", "Not Auth");
				response.sendRedirect("./Login");
			}
		}
	}

	/**
	 * MySQLでアカウントを管理
	 * データベースを参照してメアドとパスワードで認証する
	 * 返り値はユーザーが存在するならユーザーネームを、しないならnullを返す
	 * @param email
	 * @param pass
	 * @return name
	 */
	protected String authUser(String email, String pass){
		/* 取りあえずユーザー名とパスワードが入力されていれば認証する */
		DataSource dataSource = null;
		Connection conn = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/users");
			conn = dataSource.getConnection();

			String sql = "select * from users where email = ? and pass = ?;";

			// SQLインジェクション対策
			PreparedStatement patmt = conn.prepareStatement(sql);
			patmt.setString(1, email);
			patmt.setString(2, pass);

			// emailとpassで一緒のを出力
			ResultSet rs = patmt.executeQuery();

			// selectで出て来たのをwhileで回す
			// whileに入った時点でusersテーブルに存在していたことになるのでreturn trueで返す
			while (rs.next()) {
				// nameカラムのstringを返す
				return rs.getString("name");
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return null;
	}

}
