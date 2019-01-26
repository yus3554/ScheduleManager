package schedule.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.InitialContext;
import javax.sql.DataSource;

public class NotifTable {

	public NotifTable() {

	}

	// answerをanswersテーブルにインサート
	// typeは0で新規、1で再送、2で決定
	public void insert(String[] randomURL, String notifTime, int type) {
		DataSource dataSource = null;
		Connection conn = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 WebContent/META-INF/context.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/notifs");
			conn = dataSource.getConnection();

			String sql = "insert into notifs values (?, ?, ?);";
			PreparedStatement patmt = conn.prepareStatement(sql);

			for(String url: randomURL) {
				patmt.setString(1, url);
				patmt.setString(2, notifTime);
				patmt.setInt(3, type);

				patmt.executeUpdate();
			}

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
	}

	public void insert(String randomURL, String notifTime, int type) {
		DataSource dataSource = null;
		Connection conn = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 WebContent/META-INF/context.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/notifs");
			conn = dataSource.getConnection();

			String sql = "insert into notifs values (?, ?, ?);";
			PreparedStatement patmt = conn.prepareStatement(sql);

			patmt.setString(1, randomURL);
			patmt.setString(2, notifTime);
			patmt.setInt(3, type);

			patmt.executeUpdate();

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
	}

	// 現在の時間を入れてnotifリストを返す
	public ArrayList<HashMap<String, String>> getNotifList(String nowTime) {
		ArrayList<HashMap<String, String>> notifs = new ArrayList<>();
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/notifs");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from notifs where notifTime = \"" +
					nowTime + "\";";

			// HashMapに入れてそれをArrayListに格納
			// HashMapはwhileでループごとに毎回初期化する必要がある
			ResultSet rs = stmt.executeQuery(sql);
			HashMap<String, String> hm;
			while (rs.next()) {
				hm = new HashMap<>();
				hm.put("randomURL", rs.getString("randomURL"));
				hm.put("type", rs.getString("type"));
				notifs.add(hm);
			}

			return notifs;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(stmt != null) {
					stmt.close();
				}
				if(conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	public void delete(String randomURL) {
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/notifs");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "delete from notifs where randomURL = \"" + randomURL + "\";";

			stmt.executeUpdate(sql);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(stmt != null) {
					stmt.close();
				}
				if(conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

}
