public with sharing class GoogleFormWrapper {
    public class TextQuestion {
	}

	public String formId;
	public Info info;
	public String revisionId;
	public String responderUri;
	public List<Items> items;

	public class Question_Y {
		public String questionId;
		public TextQuestion textQuestion;
	}

	public class Question_Z {
		public String questionId;
		public DateQuestion dateQuestion;
	}

	public class QuestionItem_Z {
		public Question_Z question;
	}

	public class Question {
		public String questionId;
		public Boolean required;
		public TextQuestion textQuestion;
	}

	public class Items {
		public String itemId;
		public String title;
		public QuestionItem questionItem;
	}

	public class Info {
		public String title;
		public String description;
		public String documentTitle;
	}

	public class QuestionItem {
		public Question question;
	}

	public class QuestionItem_Y {
		public Question_Y question;
	}

	public class DateQuestion {
		public Boolean includeYear;
	}

	
	public static GoogleFormWrapper parse(String json) {
		return (GoogleFormWrapper) System.JSON.deserialize(json, GoogleFormWrapper.class);
	}
}