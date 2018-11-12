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

public class ScheduleTable {

	public ScheduleTable() {
	}

	// scheduleをschedulesテーブルにインサート
	public void insert(Schedule schedule) {
		DataSource dataSource = null;
		Connection conn = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/schedules");
			conn = dataSource.getConnection();

			// 新規スケジュールをschedulesテーブルにインサート
			String sql = "insert into schedules (id, eventName, eventContent, eventStartDate, "
					+ "eventEndDate, eventDeadlineDate, senderEmail, fileName, `condition`, isInputInform)"
					+ " values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
			PreparedStatement patmt = conn.prepareStatement(sql);
			patmt.setString(1, schedule.getId());
			patmt.setString(2, schedule.getEventName());
			patmt.setString(3, schedule.getEventContent());
			patmt.setString(4, schedule.getEventStartDate());
			patmt.setString(5, schedule.getEventEndDate());
			patmt.setString(6, schedule.getEventDeadlineDate());
			patmt.setString(7, schedule.getSenderEmail());
			patmt.setString(8, schedule.getFileName());
			patmt.setString(9, schedule.getCondition());
			patmt.setBoolean(10, schedule.getIsInputInform());

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

	// senderEmailを入れて全てのスケジュールを返す
	public ArrayList<HashMap<String, String>> getScheduleList(String senderEmail) {
		ArrayList<HashMap<String, String>> list = new ArrayList<>();
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/schedules");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from schedules where senderEmail = \"" + senderEmail +"\";";

			// HashMapに入れてそれをArrayListに格納
			// HashMapはwhileでループごとに毎回初期化する必要がある
			ResultSet rs = stmt.executeQuery(sql);
			HashMap<String, String> hm;
			while (rs.next()) {
				hm = new HashMap<>();
				hm.put("id", rs.getString("id"));
				hm.put("eventName", rs.getString("eventName"));
				hm.put("eventContent", rs.getString("eventContent"));
				hm.put("eventStartDate", rs.getString("eventStartDate"));
				hm.put("eventEndDate", rs.getString("eventEndDate"));
				hm.put("eventDeadlineDate", rs.getString("eventDeadlineDate"));
				hm.put("decideDate", rs.getString("decideDate"));
				list.add(hm);
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
	public HashMap<String, String> getSchedule(String id, String senderEmail) {
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/schedules");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from schedules where id = \"" +
					id +
					"\" and senderEmail = \"" +
					senderEmail +"\";";

			ResultSet rs = stmt.executeQuery(sql);

			// HashMapに格納
			HashMap<String, String> hm = new HashMap<>();
			while (rs.next()) {
				hm.put("id", rs.getString("id"));
				hm.put("eventName", rs.getString("eventName"));
				hm.put("eventContent", rs.getString("eventContent"));
				hm.put("eventStartDate", rs.getString("eventStartDate"));
				hm.put("eventEndDate", rs.getString("eventEndDate"));
				hm.put("eventDeadlineDate", rs.getString("eventDeadlineDate"));
				hm.put("decideDate", rs.getString("decideDate"));
				hm.put("note", rs.getString("note"));
				hm.put("condition", rs.getString("condition"));
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
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/schedules");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "delete from schedules where id = \"" +
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

	// idとsenderEmailで検索をかけて、日時決定のデータを上書きする
		public void updateDecideDate(String id, String senderEmail, ArrayList<String> decideDates, String note) {
			DataSource dataSource = null;
			Connection conn = null;
			Statement stmt = null;
			try {
				InitialContext context = new InitialContext();
				// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
				dataSource = (DataSource) context.lookup("java:comp/env/jdbc/schedules");
				conn = dataSource.getConnection();

				// senderEmailで検索
				String sql = "update schedules set decideDate = ?, note = ? where id = ? and senderEmail = ?;";
				PreparedStatement patmt = conn.prepareStatement(sql);

				// 決定日時が複数の時は、カンマで区切って全部繋げて一つの文字列にする
				String decideDate = "";
				for(int i = 0; i < decideDates.size(); i++) {
					decideDate += decideDates.get(i);
					decideDate += ",";
				}
				if(decideDate != null && decideDate.length() > 0){
					decideDate = decideDate.substring(0, decideDate.length()-1);
				}
				patmt.setString(1, decideDate);
				patmt.setString(2, note);
				patmt.setString(3, id);
				patmt.setString(4, senderEmail);

				patmt.executeUpdate();

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
