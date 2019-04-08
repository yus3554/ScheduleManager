package schedule.userview;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Servlet implementation class AjaxTest
 */
@WebServlet("/AjaxTest")
public class AjaxTest extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AjaxTest() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

	        //パラメータ取得
			String strJson = (String)request.getParameter("answers");
			JSONObject jsonObject = JSONObject.fromObject(strJson);

	        int colSize = (int)jsonObject.get("colSize");
	        int rowSize = (int)jsonObject.get("rowSize");

	        /*
	        if(Objects.isNull(colSize)) {

	        }*/
	        //配列の取得
	        if (jsonObject.get("answer") != null) {
	            JSONArray array = JSONArray.fromObject(jsonObject.get("answer"));
	            for(int i = 0; i < array.size(); i++){
	                //配列の表示
	                System.out.println(array.get(i).toString());

	            }
	        }

	        //処理（DB呼び出し等）
	        String responseMsg = "成功";

	        //出力(レスポンスをmapに格納してJSON化)

	        //JSONマップ
	        Map<String, String> mapMsg = new HashMap<String, String>();

	        //追加
	        mapMsg.put("responseMsg", responseMsg);

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


}
