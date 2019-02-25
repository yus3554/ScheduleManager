package schedule.model;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;

public class DateComparator implements Comparator<ScheduleDate> {
	@Override
    public int compare(ScheduleDate sd1, ScheduleDate sd2) {
		String sdate1 = sd1.getDate();
		String sdate2 = sd2.getDate();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		int diff = 0;

		try {
			Date date1 = sdf.parse(sdate1);
			Date date2 = sdf.parse(sdate2);
			diff = date1.compareTo(date2);
		} catch (ParseException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}
		return diff;
	}
}
