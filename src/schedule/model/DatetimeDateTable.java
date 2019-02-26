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

public class DatetimeDateTable {

	public DatetimeDateTable() {
	}

	// scheduleをschedulesテーブルにインサート
	public void insert(String id, String senderEmail, ArrayList<String> datetimes) {
		DataSource dataSource = null;
		Connection conn = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/datetimeDates");
			conn = dataSource.getConnection();

			String sql = "insert into datetimeDates (id, senderEmail, date) values (?, ?, ?);";
			PreparedStatement patmt = conn.prepareStatement(sql);

			for(int i = 0; i < datetimes.size(); i++) {
				patmt.setString(1, id);
				patmt.setString(2, senderEmail);
				patmt.setString(3, datetimes.get(i).replace("/", "-"));
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

	// idとsenderEmailを入れて一つのスケジュールを返す
	public ArrayList<String> getDates(String id, String senderEmail) {
		ArrayList<String> dates = new ArrayList<>();
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/datetimeDates");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from datetimeDates where id = \"" +
					id + "\" and senderEmail = \"" + senderEmail +"\";";

			ResultSet rs = stmt.executeQuery(sql);

			// HashMapに格納

			while (rs.next()) {
				dates.add(rs.getString("date"));
			}

			return dates;

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

	// idとsenderEmailを入れて削除する
	public void delete(String id, String senderEmail) {
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/datetimeDates");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "delete from datetimeDates where id = \"" +
					id +
					"\" and senderEmail = \"" +
					senderEmail + "\";";

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
