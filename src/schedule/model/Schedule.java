package schedule.model;

public class Schedule {
	private String id;
	private String eventName;
	private String eventContent;
	private String eventStartDate;
	private String eventEndDate;
	private String eventDeadlineDate;
	private String senderEmail;
	private String fileName;
	private boolean isEventCondition;
	private int eventConditionNumer;
	private int eventConditionDenom;
	private boolean isInputInform;

	public Schedule(String id, String eventName, String eventContent, String eventStartDate,
			String eventEndDate, String eventDeadlineDate, String senderEmail, String fileName,
			boolean isEventCondition, int eventConditionNumer, int eventConditionDenom, boolean isInputInform) {
		this.id = id;
		this.eventName = eventName;
		this.eventContent = eventContent;
		this.eventStartDate = eventStartDate;
		this.eventEndDate = eventEndDate;
		this.eventDeadlineDate = eventDeadlineDate;
		this.senderEmail = senderEmail;
		this.fileName = fileName;
		this.isEventCondition = isEventCondition;
		this.eventConditionNumer = eventConditionNumer;
		this.eventConditionDenom = eventConditionDenom;
		this.isInputInform = isInputInform;
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

	public String getEventStartDate() {
		return eventStartDate;
	}

	public String getEventEndDate() {
		return eventEndDate;
	}

	public String getEventDeadlineDate() {
		return eventDeadlineDate;
	}

	public String getSenderEmail() {
		return senderEmail;
	}

	public String getFileName() {
		return fileName;
	}

	public String getCondition() {
		return (isEventCondition) ? eventConditionNumer + "/" + eventConditionDenom : null;
	}

	public boolean getIsInputInform() {
		return isInputInform;
	}

}
