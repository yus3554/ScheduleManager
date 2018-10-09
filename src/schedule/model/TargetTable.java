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

import org.apache.commons.lang3.RandomStringUtils;


public class TargetTable {

	public TargetTable() {

	}

	public void insert(String id, String senderEmail, String targetEmail) {
		String randomURL;
		// randamURLの被りがなくなるまでrandamURLを出力
		do {
			randomURL = createRandomURL();
		}while(isSameURL(randomURL));

		DataSource dataSource = null;
		Connection conn = null;

		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/targets");
			conn = dataSource.getConnection();

			String sql = "insert into targets value (?, ?, ?, ?, 0, null);";

			PreparedStatement patmt = conn.prepareStatement(sql);
			patmt.setString(1, id);
			patmt.setString(2, senderEmail);
			patmt.setString(3, targetEmail);
			patmt.setString(4, randomURL);

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

	// tableのなかに同じrandomURLがあるかどうか
	// あったら他のrandomURLを出力、ないならそのまま
	private boolean isSameURL(String randomURL) {
		if (getTarget(randomURL).size() <= 0) {
			return false;
		} else {
			return true;
		}
	}

	// urlに使うランダム文字列を出力する
	private String createRandomURL() {
		// common-langを使ってランダムな20文字の文字列を出力
		String url = RandomStringUtils.randomAlphanumeric(20);
		return url;
	}

	// randomURLからアドレスを取り出す
	public HashMap<String, String> getTarget(String randomURL) {
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/targets");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from targets where randomURL = \"" +
							randomURL + "\";";

			ResultSet rs = stmt.executeQuery(sql);
			HashMap<String, String> hm = new HashMap<>();
			while (rs.next()) {
				hm.put("id", rs.getString("id"));
				hm.put("senderEmail", rs.getString("senderEmail"));
				hm.put("targetEmail", rs.getString("targetEmail"));
				hm.put("isInput", rs.getString("isInput"));
				hm.put("note", rs.getString("note"));
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

	// targetEmailからrandomURLを取り出す
	public String getRandomURL(String id, String senderEmail, String targetEmail) {

		String randomURL = "";
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/targets");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from targets where targetEmail = \"" +
							targetEmail + "\" and id = \"" +
							id + "\" and senderEmail = \"" +
							senderEmail + "\";";

			ResultSet rs = stmt.executeQuery(sql);
			while (rs.next()) {
				randomURL = rs.getString("randomURL");
			}
			return randomURL;

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
		return randomURL;
	}

	// idとsenderEmailから対象のメールアドレスなどを取得
	public ArrayList<HashMap<String, String>> getTargetList(String id, String senderEmail){
		ArrayList<HashMap<String, String>> list = new ArrayList<>();
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/targets");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from targets where id = \"" +
							id + "\" and senderEmail = \"" +
							senderEmail + "\";";

			ResultSet rs = stmt.executeQuery(sql);
			HashMap<String, String> hm;
			while (rs.next()) {
				hm = new HashMap<>();
				hm.put("targetEmail", rs.getString("targetEmail"));
				hm.put("randomURL", rs.getString("randomURL"));
				hm.put("isInput", rs.getString("isInput"));
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

	// idとsenderEmailを入れて削除する
	public void delete(String id, String senderEmail) {
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/targets");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "delete from targets where id = \"" +
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

	public void isInputUpdate(String randomURL, String note) {
		DataSource dataSource = null;
		Connection conn = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/targets");
			conn = dataSource.getConnection();

			String sql = "update targets set isInput = 1, note = ? where randomURL = \"" + randomURL + "\";";
			PreparedStatement patmt = conn.prepareStatement(sql);
			patmt.setString(1, note);

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

}
