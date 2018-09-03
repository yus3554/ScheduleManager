package schedule.model;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.InitialContext;
import javax.sql.DataSource;

public class AnswerTable {

	public AnswerTable() {
	}

	// answerをanswersテーブルにインサート
	public void insert(Answer answer) {
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/answers");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			String[] targetEmails = answer.getTargetEmails();
			LocalDate startDate = LocalDate.parse(answer.getEventStartDate());
			LocalDate ld;

			for(String email: targetEmails) {
				ld = startDate;
				// targetにメールアドレスを登録
				if (email != "") {
					new TargetTable().insert(answer.getId(), answer.getSenderEmail(), email);

					String randomURL = new TargetTable().getRandomURL(answer.getId(), answer.getSenderEmail(), email);

					for(int i = 0; i < answer.getDateLength() + 1; i++) {
						// answersテーブルにインサート
						String sql = "insert into answers values (\"" +
								randomURL + "\",\"" +
								ld.toString() + "\",\"" +
								"0" + "\",\"" +
								"0" + "\",\"" +
								"0" + "\",\"" +
								"0" + "\",\"" +
								"0" + "\");";
						ld = ld.plusDays(1);

						stmt.executeUpdate(sql);
					}
				}
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

	// idとsenderEmailとtargetEmailを入れて対応するanswerを返す
	public ArrayList<HashMap<String, String>> getEmailAnswers(String randomURL) {
		ArrayList<HashMap<String, String>> answers = new ArrayList<>();
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/answers");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "select * from answers where randomURL = \"" +
					randomURL + "\";";

			// HashMapに入れてそれをArrayListに格納
			// HashMapはwhileでループごとに毎回初期化する必要がある
			ResultSet rs = stmt.executeQuery(sql);
			HashMap<String, String> hm;
			while (rs.next()) {
				hm = new HashMap<>();
				hm.put("randomURL", rs.getString("randomURL"));
				hm.put("date", rs.getString("date"));
				hm.put("first", rs.getString("first"));
				hm.put("second", rs.getString("second"));
				hm.put("third", rs.getString("third"));
				hm.put("fourth", rs.getString("fourth"));
				hm.put("fifth", rs.getString("fifth"));
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
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/answers");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// 丸の数なら2、丸と三角の数なら1
			int n = 2;

			// senderEmailで検索
			String sql = "select date, count(first >= " + n + " or null) as first, " +
						 "count(second >= " + n + " or null) as second, " +
						 "count(third >= " + n + " or null) as third, " +
						 "count(fourth >= " + n + " or null) as fourth, " +
						 "count(fifth >= " + n + " or null) as fifth " +
						 "from answers where ";
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
				hm.put("first", rs.getString("first"));
				hm.put("second", rs.getString("second"));
				hm.put("third", rs.getString("third"));
				hm.put("fourth", rs.getString("fourth"));
				hm.put("fifth", rs.getString("fifth"));
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
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/answers");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			// senderEmailで検索
			String sql = "delete from answers where randomURL = \"" + randomURL + "\";";

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

	public void update(String randomURL, String[] date, String[] first, String[] second, String[] third, String[] fourth, String[] fifth) {
		DataSource dataSource = null;
		Connection conn = null;
		Statement stmt = null;
		try {
			InitialContext context = new InitialContext();
			// lookupのjdbc/以下がテーブル名 context.xmlやweb.xmlと合わせる
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/answers");
			conn = dataSource.getConnection();

			stmt = conn.createStatement();

			int size = date.length;
			String sql = "";

			for(int i = 0; i < size; i++) {
				sql = "update answers set first = \"" + first[i] +
						"\", second = \"" + second[i] +
						"\", third = \"" + third[i] +
						"\", fourth = \"" + fourth[i] +
						"\", fifth = \"" + fifth[i] +
						"\" where date = \"" + date[i] +
						"\" and randomURL = \"" + randomURL +
						"\";";
				stmt.executeUpdate(sql);
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
