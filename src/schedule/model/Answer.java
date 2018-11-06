package schedule.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;

public class Answer {

	private String id;
	private ArrayList<String> targetEmails;
	private String senderEmail;
	private String eventStartDate;
	private String eventEndDate;
	private ArrayList<Boolean> keys;

	public Answer(String id, ArrayList<String> targetEmails, String senderEmail, String eventStartDate, String eventEndDate, ArrayList<Boolean> keys) {
		this.id = id;
		this.targetEmails = targetEmails;
		this.senderEmail = senderEmail;
		this.eventStartDate = eventStartDate;
		this.eventEndDate = eventEndDate;
		this.keys = keys;
	}

	public String getId() {
		return id;
	}

	public ArrayList<String> getTargetEmails() {
		return targetEmails;
	}

	public String getSenderEmail() {
		return senderEmail;
	}

	public String getEventStartDate() {
		return eventStartDate;
	}

	public String getEventEndDate() {
		return eventEndDate;
	}

	public ArrayList<Boolean> getKeys() {
		return keys;
	}

	// startとendの差を求める
	// end - start の日数が返ってくる
	public long getDateLength() {
		LocalDate startDate = LocalDate.parse(eventStartDate);
		LocalDate endDate = LocalDate.parse(eventEndDate);

		long length = ChronoUnit.DAYS.between(startDate, endDate);
		return length;
	}
}
