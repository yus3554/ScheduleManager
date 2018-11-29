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

public class ScheduleDateTable {

	public ScheduleDateTable() {
	}

	// scheduleをschedulesテーブルにインサート
	public void insert(Schedule schedule, ArrayList<ScheduleDate> sdList) {
		DataSource dataSource = null;
		Connection conn = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/scheduleDates");
			conn = dataSource.getConnection();

			String sql = "insert into scheduleDates (id,"
					+ "senderEmail, date, first, second, third, fourth, fifth)"
					+ " values (?, ?, ?, ?, ?, ?, ?, ?);";
			PreparedStatement patmt = conn.prepareStatement(sql);

			for(int i = 0; i < sdList.size(); i++) {
				patmt.setString(1, schedule.getId());
				patmt.setString(2, schedule.getSenderEmail());
				patmt.setString(3, sdList.get(i).getDate());
				for(int j = 0; j < sdList.get(i).getTimes().length; j++) {
					patmt.setInt(j + 4, sdList.get(i).getTime(j));
				}
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

	// senderEmailを入れて全てのスケジュールを返す
	public ArrayList<ScheduleDate> getDateList(String id, String senderEmail) {
		ArrayList<ScheduleDate> list = new ArrayList<>();
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/scheduleDates");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from scheduleDates where id = \""
					+ id +"\" and senderEmail = \"" + senderEmail + "\";";

			// HashMapに入れてそれをArrayListに格納
			// HashMapはwhileでループごとに毎回初期化する必要がある
			ResultSet rs = stmt.executeQuery(sql);
			while (rs.next()) {
				ScheduleDate sd = new ScheduleDate(rs.getString("date"));
				int[] times = {rs.getInt("first"), rs.getInt("second"), rs.getInt("third"), rs.getInt("fourth"), rs.getInt("fifth")};
				sd.setTimes(times);
				list.add(sd);
			}

			return list;

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

	// idとsenderEmailを入れて一つのスケジュールを返す
	public HashMap<String, String> getDate(String id, String senderEmail) {
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/scheduleDates");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from scheduleDates where id = \"" +
					id + "\" and senderEmail = \"" + senderEmail +"\";";

			ResultSet rs = stmt.executeQuery(sql);

			// HashMapに格納
			HashMap<String, String> hm = new HashMap<>();
			while (rs.next()) {
				hm.put("date", rs.getString("date"));
				hm.put("first", rs.getString("first"));
				hm.put("second", rs.getString("second"));
				hm.put("third", rs.getString("third"));
				hm.put("fourth", rs.getString("fourth"));
				hm.put("fifth", rs.getString("fifth"));
			}

			return hm;

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
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/scheduleDates");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "delete from scheduleDates where id = \"" +
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
