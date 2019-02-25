package schedule.userview;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import schedule.model.RequestAttachment;
import schedule.model.RequestAttachmentTable;
import schedule.model.TargetAttachmentTable;

/**
 * Servlet implementation class Download
 */
@WebServlet("/Download/*")
public class Download extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Download() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// urlからrandomURLやfileNameを取得
    	// 1文字目には"\"が入っているので2文字目からを代入
    	String url = request.getPathInfo().substring(1);
    	// targetかrequestのどっちか
    	int isTR = 0;
    	if( url.indexOf("/") == 6 ) { // target
    		isTR = 0;
    		url = url.substring(7);
    	} else if (url.indexOf("/") == 7) { // request
    		isTR = 1;
    		url = url.substring(8);
    	} else {
    		isTR = -1;
    	}

    	InputStream is = null;
    	String fileName = "";

    	// target
    	if(isTR == 0) {
    		String randomURL = url.substring(0, 64);
    		fileName = url.substring(65);

    		is = new TargetAttachmentTable().getFile(randomURL, fileName);
    	}
    	// request
    	if(isTR == 1) {
    		String id = url.substring(0, 23);
    		String senderEmail = url.substring(24, 24 + (url.substring(24)).indexOf("/"));
    		fileName = url.substring(24 + (url.substring(24)).indexOf("/") + 1);
    		System.out.println("fileName : " + fileName);

    		is = new RequestAttachmentTable().getFile(id, senderEmail, fileName);
    	}

    	if(is != null) {
    		String encodedFilename = URLEncoder.encode(fileName, "UTF-8");
    		response.setHeader("Content-Disposition","attachment;" + "filename*=\"UTF-8''" + encodedFilename + "\"");

    		try(OutputStream out = response.getOutputStream()) {

    			byte[] buffer = new byte[1024];

    			int numBytesRead;
    			while ((numBytesRead = is.read(buffer)) > 0) {
    				out.write(buffer, 0, numBytesRead);
    			}
    		}
    	} else {
        	response.setContentType("text/html; charset=UTF-8");
    		PrintWriter pw = response.getWriter();
    		pw.println("ファイルが存在しません。");
    	}
	}

}
