package schedule.userview;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Servlet implementation class TestAjax
 */
@WebServlet("/TestAjax")
public class TestAjax extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public TestAjax() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

	        //パラメータ取得
	        String param1 = request.getParameter("param1");
	        String param2 = request.getParameter("param2");

	        System.out.println(param1 + param2);

	        //処理（DB呼び出し等）
	        String response1 = "hello";
	        String response2 = "bye";

	        //出力(レスポンスをmapに格納してJSON化)

	        //JSONマップ
	        Map<String, String> mapMsg = new HashMap<String, String>();

	        //追加
	        mapMsg.put("response1", response1);
	        mapMsg.put("response2", response2);

	        //マッパ(JSON <-> Map, List)
	        ObjectMapper mapper = new ObjectMapper();

	        //json文字列
	        String jsonStr = mapper.writeValueAsString(mapMsg);  //list, map

	        //ヘッダ設定
	        response.setContentType("application/json;charset=UTF-8");   //JSON形式, UTF-8

	        //pwオブジェクト
	        PrintWriter pw = response.getWriter();

	        //出力
	        pw.print(jsonStr);

	        //クローズ
	        pw.close();

	    } catch(Exception e) {
	        e.printStackTrace();
	    }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
