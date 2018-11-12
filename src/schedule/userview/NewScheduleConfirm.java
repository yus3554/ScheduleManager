package schedule.userview;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;


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
		String eventStartDate = "";
		String eventEndDate = "";
		String eventDeadlineDate = "";
		ArrayList<String> temp1Keys = new ArrayList<>();
		ArrayList<Integer> temp2Keys = new ArrayList<>();
		ArrayList<Boolean> keys = new ArrayList<>();
		ArrayList<String> tempTargetEmails = new ArrayList<>();
		ArrayList<String> targetEmails = new ArrayList<>();
		boolean isEventCondition = false;
		int eventConditionNumer = 0;
		int eventConditionDenom = 0;
		boolean isInputInform = false;

		// 念の為セッション内を削除
		session.removeAttribute("eventName");
		session.removeAttribute("eventContent");
		session.removeAttribute("eventStartDate");
		session.removeAttribute("eventEndDate");
		session.removeAttribute("targetEmails");
		session.removeAttribute("eventDeadlineDate");
		session.removeAttribute("fileName");
		session.removeAttribute("file");
		session.removeAttribute("isEventCondition");
		session.removeAttribute("eventConditionNumer");
		session.removeAttribute("eventConditionDenom");
		session.removeAttribute("isInputInform");

		try {
    		List list = sfu.parseRequest(new ServletRequestContext(request));
    		Iterator iterator = list.iterator();

    		while(iterator.hasNext()){
    			FileItem item = (FileItem)iterator.next();;

    			// アップロードされたファイルのみ対象の処理
    			if (!item.isFormField()){
    				fileName = item.getName();
    				if ((fileName != null) && (!fileName.equals(""))) {
    					fileName = (new File(fileName)).getName();
    					session.setAttribute("fileName", fileName);
    					session.setAttribute("file", item);
    				}
    			} else {
    				String name = item.getFieldName();
    			    String value = item.getString("utf-8");
    			    switch(name) {
    			    case "eventName":
    			    	eventName = value;
    			    	break;
    			    case "eventContent":
    			    	eventContent = value;
    			    	eventContent = eventContent.replace("\n", "");
    					eventContent = eventContent.replace("\r", "<br>");
    					eventContent = eventContent.replace("\r\n", "<br>");
    			    	break;
    			    case "eventStartDate":
    			    	eventStartDate = value;
    			    	break;
    			    case "eventEndDate":
    			    	eventEndDate = value;
    			    	break;
    			    // キーパーソン
    			    case "key":
    			    	temp1Keys.add(value);
    			    	break;
    			    case "targetEmail[]":
    		    		tempTargetEmails.add(value);
    		    		break;
    			    case "eventDeadlineDate":
    			    	eventDeadlineDate = value;
    			    	break;
    			    // イベントの開催条件のチェック
    			    case "isEventCondition":
    			    	isEventCondition = Boolean.valueOf(value);
    			    	break;
    			    // イベントの開催条件の分子
    			    case "eventConditionNumer":
    			    	eventConditionNumer = Integer.parseInt(value);
    			    	break;
    			    // イベントの開催条件の分母
    			    case "eventConditionDenom":
    			    	eventConditionDenom = Integer.parseInt(value);
    			    	break;
    			    // 回答者に現在の回答状況を伝えるかどうかのチェック
    			    case "isInputInform":
    			    	isInputInform = Boolean.valueOf(value);
    			    	break;
    		    	default:
    			    }
    			}
    		}

    	}catch (FileUploadException e) {
    		e.printStackTrace();
    	}catch (Exception e) {
    		  e.printStackTrace();
    	}

		// とりあえず空欄を抜いて、空欄に合わせてキーパーソン内の添字を変更
		int times = 0;
		for(int i = 0; i < tempTargetEmails.size(); i++) {
			if(!tempTargetEmails.get(i).equals("") && tempTargetEmails.get(i) != null) {
				targetEmails.add(tempTargetEmails.get(i));
				for(int j = 0; j < temp1Keys.size(); j++) {
					if(Integer.parseInt(temp1Keys.get(j)) == i + 1) {
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
		// 取得した要素をsessionに保存
		session.setAttribute("eventName", eventName);
		session.setAttribute("eventContent", eventContent);
		session.setAttribute("eventStartDate", eventStartDate);
		session.setAttribute("eventEndDate", eventEndDate);
		session.setAttribute("targetEmails", targetEmails);
		session.setAttribute("keys", keys);
		session.setAttribute("eventDeadlineDate", eventDeadlineDate);
		session.setAttribute("isEventCondition", isEventCondition);
		session.setAttribute("eventConditionNumer", eventConditionNumer);
		session.setAttribute("eventConditionDenom", eventConditionDenom);
		session.setAttribute("isInputInform", isInputInform);

		// jspを指定
		String view = "/WEB-INF/view/user/newscheduleconfirm.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);

	}

}
