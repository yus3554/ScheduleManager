package schedule.userview;

import java.io.File;
import java.io.IOException;
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

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

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

		String path = getServletContext().getRealPath("cache");

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
		String targetEmail1 = "";
		String targetEmail2 = "";
		String targetEmail3 = "";
		String targetEmail4 = "";
		String targetEmail5 = "";

		try {
    		List list = sfu.parseRequest(request);
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
    			    case "targetEmail1":
    			    	targetEmail1 = value;
    			    	break;
    			    case "targetEmail2":
    			    	targetEmail2 = value;
    			    	break;
    			    case "targetEmail3":
    			    	targetEmail3 = value;
    			    	break;
    			    case "targetEmail4":
    			    	targetEmail4 = value;
    			    	break;
    			    case "targetEmail5":
    			    	targetEmail5 = value;
    			    	break;
    			    case "eventDeadlineDate":
    			    	eventDeadlineDate = value;
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

		String[] targetEmails = {targetEmail1,targetEmail2,targetEmail3,targetEmail4,targetEmail5};

		// 取得した要素をsessionに保存
		session.setAttribute("eventName", eventName);
		session.setAttribute("eventContent", eventContent);
		session.setAttribute("eventStartDate", eventStartDate);
		session.setAttribute("eventEndDate", eventEndDate);
		session.setAttribute("targetEmails", targetEmails);
		session.setAttribute("eventDeadlineDate", eventDeadlineDate);

		// jspを指定
		String view = "/WEB-INF/view/user/newscheduleconfirm.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);

	}

}
