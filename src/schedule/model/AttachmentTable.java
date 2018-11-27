package schedule.model;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.InitialContext;
import javax.sql.DataSource;

public class AttachmentTable {

	public AttachmentTable() {
	}

	// answerをanswersテーブルにインサート
	public void insert(String id, String senderEmail, String fileName, InputStream stream) {
		DataSource dataSource = null;
		Connection conn = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/attachments");
			conn = dataSource.getConnection();

			String sql = "insert into attachments values (?, ?, ?, ?);";
			PreparedStatement patmt = conn.prepareStatement(sql);

			patmt.setString(1, id);
			patmt.setString(2, senderEmail);
			patmt.setString(3, fileName);
			patmt.setBlob(4, stream);

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

	// idとsenderEmailを入れて対応するanswerを返す
	public ArrayList<Attachment> getFiles(String id, String senderEmail) {
		ArrayList<Attachment> files = new ArrayList<>();
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/attachments");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from attachments where id = \"" +
					id + "\" and senderEmail = \"" + senderEmail + "\";";

			// HashMapに入れてそれをArrayListに格納
			// HashMapはwhileでループごとに毎回初期化する必要がある
			ResultSet rs = stmt.executeQuery(sql);
			Attachment am;
			while (rs.next()) {
				am = new Attachment(rs.getString("fileName"), (rs.getBlob("file")).getBinaryStream());
				files.add(am);
			}

			return files;

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
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/attachments");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "delete from attachments where id = \"" + id + "\" and "
					+ "senderEmail = \"" + senderEmail +"\";";

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
