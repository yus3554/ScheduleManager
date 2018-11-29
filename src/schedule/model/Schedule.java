package schedule.model;

public class Schedule {
	private String id;
	private String eventName;
	private String eventContent;
	private String eventDeadline;
	private String senderEmail;
	private boolean isEventCondition;
	private int eventConditionNumer;
	private int eventConditionDenom;
	private boolean isInputInform;

	public Schedule(String id, String eventName, String eventContent, String eventDeadline, String senderEmail,
			boolean isEventCondition, int eventConditionNumer, int eventConditionDenom, boolean isInputInform) {
		this.id = id;
		this.eventName = eventName;
		this.eventContent = eventContent;
		this.eventDeadline = eventDeadline;
		this.senderEmail = senderEmail;
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

	public String getEventDeadline() {
		return eventDeadline;
	}

	public String getSenderEmail() {
		return senderEmail;
	}

	public String getCondition() {
		return (isEventCondition) ? eventConditionNumer + "/" + eventConditionDenom : null;
	}

	public boolean getIsInputInform() {
		return isInputInform;
	}

}
