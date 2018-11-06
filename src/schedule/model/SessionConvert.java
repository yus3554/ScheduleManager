package schedule.model;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

public class SessionConvert {

	private String id;
	private Schedule schedule;
	private Answer answer;
	private HttpSession session;

	public SessionConvert(String id, HttpSession session) {
		this.id = id;
		this.session = session;
	}

	public Schedule getSchedule() {
		schedule = new Schedule(
				id,
				(String)session.getAttribute("eventName"),
				(String)session.getAttribute("eventContent"),
				(String)session.getAttribute("eventStartDate"),
				(String)session.getAttribute("eventEndDate"),
				(String)session.getAttribute("eventDeadlineDate"),
				(String)session.getAttribute("email"),
				(String)session.getAttribute("fileName"));
		return schedule;
	}

	public Answer getAnswer() {
		answer = new Answer(
				id,
				(ArrayList<String>)session.getAttribute("targetEmails"),
				(String)session.getAttribute("email"),
				(String)session.getAttribute("eventStartDate"),
				(String)session.getAttribute("eventEndDate"),
				(ArrayList<Boolean>)session.getAttribute("keys"));
		return answer;
	}
}
