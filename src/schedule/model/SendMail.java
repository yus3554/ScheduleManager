package schedule.model;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.commons.text.StringEscapeUtils;

public class SendMail {

	public SendMail() {
	}

	public void send(String subject, String content, String to) {

		final String from = "";

		final String username = "";

		final String password = "";

		final String charset = "UTF-8";

		final String encoding = "base64";


		String host = "";
		String port = "";

		Properties props = new Properties();
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", port);
		props.put("mail.smtp.auth", "true");

		props.put("mail.smtp.socketFactory.port", port);
		props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		props.put("mail.smtp.connectiontimeout", "10000");
		props.put("mail.smtp.timeout", "10000");

		Session session = Session.getInstance(props,
				new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});

		try {
			MimeMessage message = new MimeMessage(session);
			message.setHeader("Content-Transfer-Encoding", encoding);

			message.setSubject(StringEscapeUtils.unescapeHtml4(subject), charset);

			// Set From:
			message.setFrom(new InternetAddress(from, "日程調整システム"));
			// Set ReplyTo:
			message.setReplyTo(new Address[]{new InternetAddress(from)});
			// Set To:
			message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));

			message.setContent(content, "text/html; charset=" + charset);

			System.out.println("-------メール送信-------");
			System.out.println("to : " + to);
			System.out.println("-------メール送信完了-------");
			Transport.send(message);

		} catch (MessagingException e) {
			throw new RuntimeException(e);
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e);
		}

	}

}
