package schedule.model;

import java.util.Arrays;

public class ScheduleDate {

	private String date;
	private int[] time = new int[5];

	public ScheduleDate(String date) {
		this.date = date;
		this.time[0] = -1;
		this.time[1] = -1;
		this.time[2] = -1;
		this.time[3] = -1;
		this.time[4] = -1;
	}

	public String getDate() {
		return date;
	}

	public int[] getTimes() {
		return time;
	}

	public int getTime(int i) {
		return time[i];
	}

	public void setTime(int i) {
		this.time[i] = 0;
	}

	public void setTimes(int[] times) {
		for(int i = 0; i < times.length; i++) {
			this.time[i] = times[i];
		}
	}

	public String toString() {
		String timeStr = " ";
		for(int i = 0; i < time.length; i++) {
			if(time[i] == 0)
				timeStr += "" + (i + 1) + "限 ";
		}
		return date + timeStr + "<br>";
	}
}
