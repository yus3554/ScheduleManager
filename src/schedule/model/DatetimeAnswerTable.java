package schedule.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DatetimeAnswerTable {

	public DatetimeAnswerTable() {
	}

	// answerをanswersテーブルにインサート
	public void insert(Answer answer, ArrayList<String> dates) {
		DataSource dataSource = null;
		Connection conn = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/datetimeAnswers");
			conn = dataSource.getConnection();

			ArrayList<String> targetEmails = answer.getTargetEmails();
			ArrayList<Boolean> keys = answer.getKeys();

			for(int i = 0; i < targetEmails.size(); i++) {
				// targetにメールアドレスを登録
				if (!targetEmails.get(i).equals("") && targetEmails.get(i) != null) {
					new TargetTable().insert(answer.getId(), answer.getSenderEmail(), targetEmails.get(i), keys.get(i));

					String randomURL = new TargetTable().getRandomURL(answer.getId(), answer.getSenderEmail(), targetEmails.get(i));

					String sql = "insert into datetimeAnswers values (?, ?, 0);";
					PreparedStatement patmt = conn.prepareStatement(sql);

					for(int j = 0; j < dates.size(); j++) {
						// answersテーブルにインサート
						patmt.setString(1, randomURL);
						patmt.setString(2, dates.get(j));
						patmt.executeUpdate();
					}
				}
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

	// idとsenderEmailとtargetEmailを入れて対応するanswerを返す
	public ArrayList<HashMap<String, String>> getEmailAnswers(String randomURL) {
		ArrayList<HashMap<String, String>> answers = new ArrayList<>();
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/datetimeAnswers");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from datetimeAnswers where randomURL = \"" +
					randomURL + "\";";

			// HashMapに入れてそれをArrayListに格納
			// HashMapはwhileでループごとに毎回初期化する必要がある
			ResultSet rs = stmt.executeQuery(sql);
			HashMap<String, String> hm;
			while (rs.next()) {
				hm = new HashMap<>();
				hm.put("date", rs.getString("date"));
				hm.put("answer", rs.getString("answer"));
				answers.add(hm);
			}

			return answers;

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

	// 丸の数を返す
	public ArrayList<HashMap<String, String>> getCountAnswers(ArrayList<String> randomURLs) {
		ArrayList<HashMap<String, String>> answers = new ArrayList<>();
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/datetimeAnswers");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// 丸の数なら2、丸と三角の数なら1
			int n = 2;

			// senderEmailで検索
			String sql = "select date, count(answer >= " + n + " or null) as answer " +
						 "from datetimeAnswers where ";
			for(String url: randomURLs) {
				if (sql.endsWith("'")) {
					sql += " or ";
				}
					sql += "randomURL = '" + url +"'";
			}
			sql += " group by date;";

			// HashMapに入れてそれをArrayListに格納
			// HashMapはwhileでループごとに毎回初期化する必要がある
			ResultSet rs = stmt.executeQuery(sql);
			HashMap<String, String> hm;
			while (rs.next()) {
				hm = new HashMap<>();
				hm.put("date", rs.getString("date"));
				hm.put("answer", rs.getString("answer"));
				answers.add(hm);
			}

			return answers;

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
	public void delete(String randomURL) {
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/datetimeAnswers");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "delete from datetimeAnswers where randomURL = \"" + randomURL + "\";";

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

	public void update(String randomURL, ArrayList<String> date, ArrayList<String> answer) {
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/datetimeAnswers");
			conn = dataSource.getConnection();

			int size = date.size();
			String sql = "update datetimeAnswers set answer = ? where date = ? and randomURL = ?;";
			PreparedStatement patmt = conn.prepareStatement(sql);

			for(int i = 0; i < size; i++) {
				patmt.setString(1, answer.get(i));
				patmt.setString(2, date.get(i));
				patmt.setString(3, randomURL);

				patmt.executeUpdate();
			}

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
