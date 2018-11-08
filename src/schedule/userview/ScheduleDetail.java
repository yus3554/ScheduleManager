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
		String decideDate = scheduleHM.get("decideDate");
		if(decideDate != null)
			decideDate = decideDate.replace(",", "<br>");
		request.setAttribute("decideDate", decideDate);
		request.setAttribute("note", scheduleHM.get("note"));

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
		}
		request.setAttribute("notInput", notInput);

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
				answer[0] = Integer.parseInt(hm.get("first"));
				answer[1] = Integer.parseInt(hm.get("second"));
				answer[2] = Integer.parseInt(hm.get("third"));
				answer[3] = Integer.parseInt(hm.get("fourth"));
				answer[4] = Integer.parseInt(hm.get("fifth"));
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
		// リマインダー（再送）の日時をそれぞれ変えられるようにする
		// jsを別ファイルに
		// キーパーソンを指定、人数の条件等、どうやって指定するか
		// 新規登録の際の確認ページが表示できない、確認メールが送られてない
		// 添付ファイルの削除
		// 日程調整を出す際に、何分の1などの開催条件を指定できるように
		// 回答ページで、答えを一時保存できるようにして欲しい
		// 備考欄が大きすぎるんじゃ無いか

		/*
		・回答ページの備考欄が大きすぎな気がします．
		→サイズを変更する

	 ・確認，じゃなく，送信，とかの方がよくないですか？
		→要確認

	 ・一時保存，があった方がよいです．
		→ブラウザの戻るボタンなどで入力がリセットされてしまうのも含めて、
		　jsのlocalstorage機能を使うべき
		　ただしサーバーに保存されているデータと競合しないように注意する

	 ・回答者の名前をどっかに表示した方が良い気がします．
		→即修正

	 ・メールに，テスト，とありますが，回答ページには必要ない？
		→即修正、スクロールする必要がないように空いている右側のスペースを使用する

	 ・メールアドレスごとにユーザのデータを管理するようにして
	  これまでの回答状況一覧とか見れるページとかあったらうれしいです．
		→あったら良いけどなかなか面倒
		*/

		// 研究室のサーバの方ではビルドパスをcommonslangとmailはプロジェクトフォルダ直下のlibフォルダからで良いが、
		// jdbcはtomcat内のlibフォルダにjarファイルを入れてそこから参照しないといけない
		// notifmanagerのメール送信のところで、添付ファイルを読み込むところで、パスを指定するが、
		// 研究室のサーバーと自分のパソコンでは異なるので、変更が必要

		// キーパーソンのやつ、あとはセルの色変える奴だけだけど、アイデアとしては、キーパーソンの2次元配列をそれぞれANDしていってできた2次元配列を使って
		// セルの色つける関数のところでtrueかfalseかで色つけるかどうか見れば良い?
		// 誰が誰にメールを送ったかわかるようにログの出力を変えておく


		// リストの長さをrequestに格納
		request.setAttribute("targetListLength", targetListLength);

		// jspを指定
		String view = "/WEB-INF/view/user/scheduledetail.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);

	}
}
