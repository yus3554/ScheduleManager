package schedule.userview;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.text.StringEscapeUtils;
import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

import schedule.model.DateComparator;
import schedule.model.ScheduleDate;


/**
 * Servlet implementation class NewScheduleConfirm
 */
@WebServlet("/NewScheduleConfirm")
public class NewScheduleConfirm extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public NewScheduleConfirm() {
		super();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");

		HttpSession session = request.getSession(false);

    	DiskFileItemFactory factory = new DiskFileItemFactory();
    	ServletFileUpload sfu = new ServletFileUpload(factory);
    	sfu.setSizeMax(5 * 1000 * 1024);
		sfu.setFileSizeMax(10 * 1000 * 1024);

		String fileName = "";
		String eventName = "";
		String eventContent = "";
		String eventDeadline = "";
		ArrayList<ScheduleDate> eventDates = new ArrayList<>();
		ArrayList<String> datetimeTemp = new ArrayList<>();
		ArrayList<String> datetime = new ArrayList<>();
		int dateType = 1;
		ArrayList<String> temp1Keys = new ArrayList<>();
		ArrayList<Integer> temp2Keys = new ArrayList<>();
		ArrayList<Boolean> keys = new ArrayList<>();
		ArrayList<String> tempTargetEmails = new ArrayList<>();
		ArrayList<String> targetEmails = new ArrayList<>();
		ArrayList<String> remindDateTimesTemp = new ArrayList<>();
		ArrayList<String> remindDateTimes = new ArrayList<>();
		boolean isRemindDeadline = false;
		boolean isInputInform = false;

		// 念の為セッション内を削除
		session.removeAttribute("eventName");
		session.removeAttribute("eventContent");
		session.removeAttribute("eventDates");
		session.removeAttribute("targetEmails");
		session.removeAttribute("keys");
		session.removeAttribute("eventDeadline");
		session.removeAttribute("remindDateTimes");
		if( session.getAttribute("fileNum") != null ) {
			for(int i = 0; i <= (int)session.getAttribute("fileNum"); i++) {
				session.removeAttribute("fileName" + i);
				session.removeAttribute("file" + i);
			}
			session.removeAttribute("fileNum");
		}
		session.removeAttribute("isInputInform");

		int fileNum = -1;
		try {
			List list = sfu.parseRequest(new ServletRequestContext(request));
			Iterator iterator = list.iterator();

			while(iterator.hasNext()){
				FileItem item = (FileItem)iterator.next();

				// アップロードされたファイルのみ対象の処理
				if (!item.isFormField()){
					fileName = item.getName();
					if ((fileName != null) && (!fileName.equals(""))) {
						fileNum++;
						fileName = (new File(fileName)).getName();
						session.setAttribute("fileName" + fileNum, fileName);
						session.setAttribute("file" + fileNum, item);
					}
				} else {
					String name = item.getFieldName();
					String value = item.getString("utf-8");
					// 候補日程の時限数
					if(name.startsWith("#")) {
						for(int i = 0; i < eventDates.size(); i++) {
							ScheduleDate date = eventDates.get(i);
							if(date.getDate().equals(name.substring(1, 11))) {
								eventDates.get(i).setTime(Integer.parseInt(value) - 1);
								break;
							}
						}
					} else {
						switch(name) {
						case "eventName":
							eventName = StringEscapeUtils.escapeHtml4(value);
							break;
						case "eventContent":
							eventContent = StringEscapeUtils.escapeHtml4(value);
							eventContent = eventContent.replace("\n", "");
							eventContent = eventContent.replace("\r", "<br>");
							eventContent = eventContent.replace("\r\n", "<br>");
							break;
						case "date[]":
							boolean b = true;
							for(int i = 0; i < eventDates.size(); i++) {
								ScheduleDate date = eventDates.get(i);
								if(date.getDate().equals(value)) {
									b = false;
								}
							}
							if( b )
								eventDates.add(new ScheduleDate(value));
							break;
						case "datetime[]":
							String temp = value;
							temp = temp.replace("\r", "\n");
							temp = temp.replace("\r\n", "\n");
							datetimeTemp.add(temp);
							break;
						case "dateType":
							dateType = Integer.parseInt(value);
							break;
							// キーパーソン
						case "key[]":
							temp1Keys.add(value);
							break;
						case "targetEmail[]":
							tempTargetEmails.add(StringEscapeUtils.escapeHtml4(value));
							break;
						case "remindDateTime[]":
							remindDateTimesTemp.add(value);
							break;
						case "isRemindDeadline":
							isRemindDeadline = Boolean.valueOf(value);
							break;
						case "eventDeadline":
							eventDeadline = value;
							break;
						// 回答者に現在の回答状況を伝えるかどうかのチェック
						case "isInputInform":
							isInputInform = Boolean.valueOf(value);
							break;
						default:
						}
					}
				}
    		}

    	}catch (FileUploadException e) {
    		e.printStackTrace();
    	}catch (Exception e) {
    		  e.printStackTrace();
    	}

		// 候補日程のソート
		DateComparator dc = new DateComparator();
		Collections.sort(eventDates, dc);

		// とりあえず空欄を抜いて、空欄に合わせてキーパーソン内の添字を変更
		int times = 0;
		for(int i = 0; i < tempTargetEmails.size(); i++) {
			String tempEmail = tempTargetEmails.get(i);
			if(!tempEmail.equals("") && tempEmail != null && !targetEmails.contains(tempEmail)) {
				targetEmails.add(tempEmail);
				for(int j = 0; j < temp1Keys.size(); j++) {
					if(Integer.parseInt(temp1Keys.get(j)) == i ) {
						temp2Keys.add(times);
					}
				}
				times++;
			}
		}
		// そして、キーパーソンの添字から、そのemailがキーパーソンであるかどうかを0or1で判別
		for(int i = 0; i < targetEmails.size(); i++) {
			if(temp2Keys.contains(i)) {
				keys.add(true);
			} else {
				keys.add(false);
			}
		}

		// リマインダーの被りがあったらいれない
		remindDateTimes = new ArrayList<>(new HashSet<>(remindDateTimesTemp));
		Collections.sort(remindDateTimes);

		// datetimeを配列に
		// 重複なくす
		ArrayList<String> dtTemp1 = new ArrayList<>(new HashSet<>(datetimeTemp));
		ArrayList<LocalDateTime> dtTemp2 = new ArrayList<>();
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm");
		for(String s : dtTemp1) {
			try {
				dtTemp2.add(LocalDateTime.parse(s, dtf));
			} catch (DateTimeParseException e) {}
		}
		Collections.sort(dtTemp2);
		for(LocalDateTime l : dtTemp2) {
			datetime.add(l.format(dtf));
		}

		// 取得した要素をsessionに保存
		session.setAttribute("eventName", eventName);
		session.setAttribute("eventContent", eventContent);
		session.setAttribute("eventDates", eventDates);
		session.setAttribute("dateType", dateType);
		session.setAttribute("datetime", datetime);
		session.setAttribute("targetEmails", targetEmails);
		session.setAttribute("keys", keys);
		session.setAttribute("fileNum", fileNum);
		session.setAttribute("remindDateTimes", remindDateTimes);
		session.setAttribute("isRemindDeadline", isRemindDeadline);
		session.setAttribute("eventDeadline", eventDeadline);
		session.setAttribute("isInputInform", isInputInform);

		// jspを指定
		String view = "/WEB-INF/view/user/newscheduleconfirm.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);

	}

}
