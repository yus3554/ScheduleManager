package schedule.model;

public class Schedule {
	private String id;
	private String eventName;
	private String eventContent;
	private String eventDeadline;
	private String senderEmail;
	private boolean isInputInform;
	private int dateType;
	private boolean isDecideFirst;

	public Schedule(String id, String eventName, String eventContent, String eventDeadline, String senderEmail,
			boolean isInputInform, int dateType, boolean isDecideFirst) {
		this.id = id;
		this.eventName = eventName;
		this.eventContent = eventContent;
		this.eventDeadline = eventDeadline;
		this.senderEmail = senderEmail;
		this.isInputInform = isInputInform;
		this.dateType = dateType;
		this.isDecideFirst = isDecideFirst;
	}

	public String getId() {
		return id;
	}

	public String getEventName() {
		return eventName;
	}

	public String getEventContent() {
		return eventContent;
	}

	public String getEventDeadline() {
		return eventDeadline;
	}

	public String getSenderEmail() {
		return senderEmail;
	}

	public boolean getIsInputInform() {
		return isInputInform;
	}

	public int getDateType() {
		return dateType;
	}

	public boolean getIsDecideFirst() {
		return isDecideFirst;
	}
}
