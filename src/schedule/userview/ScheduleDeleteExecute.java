package schedule.userview;

import java.io.File;
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

import schedule.model.ScheduleTable;
import schedule.model.TargetTable;
import schedule.model.AnswerTable;
import schedule.model.NotifTable;

/**
 * Servlet implementation class ScheduleDeleteExecute
 */
@WebServlet("/RequestSchedules/Delete/*")
public class ScheduleDeleteExecute extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ScheduleDeleteExecute() {
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

    	// 対象者全てをidとsenderEmailを使って取得
    	ArrayList<HashMap<String, String>> targetList = new ArrayList<>();
    	targetList = new TargetTable().getTargetList(id, (String)session.getAttribute("email"));

    	// scheduleListの数を取得
    	int targetListLength = targetList.size();

    	String[] randomURLs = new String[targetListLength];

    	HashMap<String, String> targetHM = new HashMap<>();

    	// 0番目からrequestにスケジュールを格納
    	for(int i = 0; i < targetListLength; i++) {
    		targetHM = targetList.get(i);
    		randomURLs[i] = targetHM.get("randomURL");
    	}

    	// リストの長さをrequestに格納
    	request.setAttribute("targetListLength", targetListLength);

    	if(session.getAttribute("deleteConfirm") != "") {

    		new ScheduleTable().delete(id, (String) session.getAttribute("email"));
    		for(int i = 0; i < targetListLength; i++) {
        		new AnswerTable().delete(randomURLs[i]);
        		new NotifTable().delete(randomURLs[i]);
        	}
    		new TargetTable().delete(id, (String) session.getAttribute("email"));
    		/* 添付ファイルをdataフォルダから削除 まだ実装できていない
    		File file = new File("/Users/yus3554/eclipse-workspace/.metadata/.plugins/"
    				+ "org.eclipse.wst.server.core/tmp1/wtpwebapps/ScheduleManager/data/" + id + "#" + fileName);
    		if (file.exists()){
    		    System.out.println("ファイルは存在します");
    		}else{
    		    System.out.println("ファイルは存在しません");
    		}
    		*/
    	}

    	// jspを指定
    	String view = "/WEB-INF/view/user/scheduledeleteexecute.jsp";
    	// リクエストをviewに飛ばす
    	RequestDispatcher dispatcher = request.getRequestDispatcher(view);

    	dispatcher.forward(request, response);
    }
}
