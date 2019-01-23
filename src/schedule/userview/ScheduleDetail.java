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
import schedule.model.ScheduleDate;
import schedule.model.ScheduleDateTable;
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

		String senderEmail = (String) session.getAttribute("email");

		// idとsenderEmailを入れてscheduleを取得
		HashMap<String, String> scheduleHM = new ScheduleTable().getSchedule(id, senderEmail);
		ArrayList<ScheduleDate> sdList = new ScheduleDateTable().getDateList(id, senderEmail);

		// scheduleをrequestに格納
		request.setAttribute("id", id);
		request.setAttribute("eventName", scheduleHM.get("eventName"));
		request.setAttribute("eventContent", scheduleHM.get("eventContent"));
		request.setAttribute("eventDates", sdList);
		request.setAttribute("eventDeadline", scheduleHM.get("eventDeadline"));
		String decideDate = scheduleHM.get("decideDate");
		if(decideDate != null)
			decideDate = decideDate.replace(",", "<br>");
		request.setAttribute("decideDate", decideDate);
		request.setAttribute("note", scheduleHM.get("note"));
		String condition = scheduleHM.get("condition");
		request.setAttribute("isEventCondition", condition == null ? false : true);
		// 分子
		request.setAttribute("eventConditionNumer", condition == null ? null : condition.split("/")[0]);
		// 分母
		request.setAttribute("eventConditionDenom", condition == null ? null : condition.split("/")[1]);

		// 対象者全てをidとsenderEmailを使って取得
		ArrayList<HashMap<String, String>> targetList = new TargetTable().getTargetList(id, (String)session.getAttribute("email"));

		// scheduleListの数を取得
		int targetListLength = targetList.size();
		request.setAttribute("targetLength", targetListLength);

		HashMap<String, String> targetHM = new HashMap<>();

		ArrayList<String> randomURLs = new ArrayList<>();

		int notInput = 0;

		// 0番目からrequestにスケジュールを格納
		for(int i = 0; i < targetListLength; i++) {
			targetHM = targetList.get(i);
			request.setAttribute("targetEmail" + i, targetHM.get("targetEmail"));
			request.setAttribute("randomURL" + i, targetHM.get("randomURL"));
			request.setAttribute("isInput" + i, targetHM.get("isInput"));
			request.setAttribute("key" + i, targetHM.get("key"));
			notInput += Integer.parseInt((String)targetHM.get("isInput")) == 0 ? 1 : 0;
			randomURLs.add(targetHM.get("randomURL"));
			request.setAttribute("sendDate" + i, targetHM.get("sendDate"));
		}
		request.setAttribute("notInput", notInput);

		// sdList、ScheduleDateListの何限があるかどうかを配列に入れる
		// そうすることで、全体回答状況表に斜線を入れたり、マウスカーソル合わせた時のポップアップを表示しないようにする
		int[][] sdTimes = new int[sdList.size()][5];
		for(int i = 0; i < sdList.size(); i++) {
			for(int j = 0; j < 5; j++) {
				sdTimes[i][j] = sdList.get(i).getTime(j);
			}
		}
		request.setAttribute("sdTimes", sdTimes);

		// 全体回答状況表のため
		String[] timeStr = {"first", "second", "third", "fourth", "fifth"};
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
			for(int j = 0; j < 5; j++) {
				counts[i][j] = Integer.parseInt(count.get(i).get(timeStr[j]));
			}
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

		// 全体回答のポップアップに使う
		// randomURLの順番で配列に入れる
		ArrayList<ArrayList<int[]>> targetsAnswers = new ArrayList<>();
		// getEmailAnswersから取得したものを格納しておく変数
		ArrayList<HashMap<String, String>> gotAnswers = new ArrayList<>();
		for(int i = 0; i < randomURLs.size(); i++) {
			gotAnswers = new AnswerTable().getEmailAnswers(randomURLs.get(i));
			// 一人分のanswerを入れる変数
			ArrayList<int[]> answers = new ArrayList<>();
			HashMap<String, String> hm = new HashMap<>();
			for(int j = 0; j < gotAnswers.size(); j++) {
				int[] answer = new int[5];
				hm = gotAnswers.get(j);
				for(int k = 0; k < 5; k++) {
					answer[k] = Integer.parseInt(hm.get(timeStr[k]));
				}
				answers.add(answer);
				hm.clear();
			}
			targetsAnswers.add(answers);
		}
		request.setAttribute("targetsAnswers", targetsAnswers);

		//TODO 全体の回答状況を動的に、三角とか丸とか変えられるようにする
		// あとは、全体のところのセルを押すと日程決定のメールを送れるようにする
		// 不正なIDやrandamURLに対するエラーページ（一応やった）
		// SSL関係の証明書とかの勉強
		// 退会ページ
		// 登録状況変更
		// 新規スケジュールの対象者アドレスのグループ化的
		// jsを別ファイルに


		// リストの長さをrequestに格納
		request.setAttribute("targetListLength", targetListLength);

		// jspを指定
		String view = "/WEB-INF/view/user/scheduledetail.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);

	}
}
