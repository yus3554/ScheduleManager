package schedule.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;

public class Answer {

	private String id;
	private ArrayList<String> targetEmails;
	private String senderEmail;
	private ArrayList<Boolean> keys;

	public Answer(String id, ArrayList<String> targetEmails, String senderEmail, ArrayList<Boolean> keys) {
		this.id = id;
		this.targetEmails = targetEmails;
		this.senderEmail = senderEmail;
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

	public ArrayList<Boolean> getKeys() {
		return keys;
	}
}
