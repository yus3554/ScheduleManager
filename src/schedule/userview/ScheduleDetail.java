package schedule.userview;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import schedule.model.AnswerTable;
import schedule.model.ScheduleTable;
import schedule.model.TargetTable;

/**
 * Servlet implementation class ScheduleDetail
 */
@WebServlet("/RequestSchedules/*")
public class ScheduleDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
	public ScheduleDetail() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// urlからidを取得
		// 1文字目には"\"が入っているので2文字目からを代入
		String id = request.getPathInfo().substring(1);

		// sessionを取得
		HttpSession session = request.getSession(false);

		// idとsenderEmailを入れてscheduleを取得
		HashMap<String, String> scheduleHM = new HashMap<String, String>();
		scheduleHM = new ScheduleTable().getSchedule(id, (String) session.getAttribute("email"));

		// scheduleをrequestに格納
		request.setAttribute("id", scheduleHM.get("id"));
		request.setAttribute("eventName", scheduleHM.get("eventName"));
		request.setAttribute("eventContent", scheduleHM.get("eventContent"));
		request.setAttribute("eventStartDate", scheduleHM.get("eventStartDate"));
		request.setAttribute("eventEndDate", scheduleHM.get("eventEndDate"));
		request.setAttribute("eventDeadlineDate", scheduleHM.get("eventDeadlineDate"));

		// 対象者全てをidとsenderEmailを使って取得
		ArrayList<HashMap<String, String>> targetList = new ArrayList<>();
		targetList = new TargetTable().getTargetList(id, (String)session.getAttribute("email"));

		// scheduleListの数を取得
		int targetListLength = targetList.size();

		HashMap<String, String> targetHM = new HashMap<>();

		ArrayList<String> randomURLs = new ArrayList<>();

		// 0番目からrequestにスケジュールを格納
		for(int i = 0; i < targetListLength; i++) {
			targetHM = targetList.get(i);
			request.setAttribute("targetEmail" + i, targetHM.get("targetEmail"));
			request.setAttribute("randomURL" + i, targetHM.get("randomURL"));
			request.setAttribute("isInput" + i, targetHM.get("isInput"));
			randomURLs.add(targetHM.get("randomURL"));
		}

		// 全体回答状況表のため
		ArrayList<HashMap<String, String>> count = new AnswerTable().getCountAnswers(randomURLs);
		int countLength = count.size();
		request.setAttribute("countLength", countLength);
		// 1限から5弦を配列に入れる
		// 配列の理由として、セルの色付けが楽そうだったから
		int[][] counts = new int[countLength][5];
		// セルの色付けに使う、最大値と最大値引く1
		int max = 0;
		int max_1 = 0;
		for(int i = 0; i < countLength; i++) {
			request.setAttribute("date" + i, count.get(i).get("date"));
			counts[i][0] = Integer.parseInt(count.get(i).get("first"));
			counts[i][1] = Integer.parseInt(count.get(i).get("second"));
			counts[i][2] = Integer.parseInt(count.get(i).get("third"));
			counts[i][3] = Integer.parseInt(count.get(i).get("fourth"));
			counts[i][4] = Integer.parseInt(count.get(i).get("fifth"));
		}
		// 最大値と最大値引く1の取得
		for(int i = 0; i < countLength; i++) {
			for(int j = 0; j < 5; j++) {
				if(max <= counts[i][j]) {
					max = counts[i][j];
				}else if(max_1 <= counts[i][j]) {
					max_1 = counts[i][j];
				}
			}
		}
		request.setAttribute("counts", counts);
		request.setAttribute("max", max);
		request.setAttribute("max_1", max_1);

		//TODO 全体の回答状況を動的に、三角とか丸とか変えられるようにする
		// あとは、全体のところのセルを押すと日程決定のメールを送れるようにする
		// 回答ページに文章で何か書けるように、備考欄を追加
		// 本文のフォントの統一（環境によって表示がバラバラになってしまう）
		// 不正なIDやrandamURLに対するエラーページ
		// SSL関係の証明書とかの勉強
		// 退会ページ
		// 登録状況変更
		// 新規スケジュールの対象者アドレスのグループ化的な
		// 中間発表のアブストラクトを作る
		// リマインダー（再送）の日時をそれぞれ変えられるようにする

		// リストの長さをrequestに格納
		request.setAttribute("targetListLength", targetListLength);

		// jspを指定
		String view = "/WEB-INF/view/user/scheduledetail.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);

	}
}
