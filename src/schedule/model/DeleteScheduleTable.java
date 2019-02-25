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

public class DeleteScheduleTable {

	public DeleteScheduleTable() {

	}

	public void insert(String[] randomURLs, String eventName) {
		DataSource dataSource = null;
		Connection conn = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 WebContent/META-INF/context.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/deleteSchedules");
			conn = dataSource.getConnection();

			String sql = "insert into deleteSchedules values (?, ?);";
			PreparedStatement patmt = conn.prepareStatement(sql);

			for(String url: randomURLs) {
				patmt.setString(1, url);
				patmt.setString(2, eventName);

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

	// 現在の時間を入れてnotifリストを返す
	public String getDeleteTitle(String randomURL) {
		String deleteTitle = null;
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/deleteSchedules");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from deleteSchedules where randomURL = \"" +
					randomURL + "\";";

			// HashMapに入れてそれをArrayListに格納
			// HashMapはwhileでループごとに毎回初期化する必要がある
			ResultSet rs = stmt.executeQuery(sql);
			while (rs.next()) {
				deleteTitle = rs.getString("eventName");
			}

			return deleteTitle;

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


}
