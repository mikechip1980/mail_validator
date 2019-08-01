package mail;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;


public class StandardInternetAddressValidator implements Validator {
    @Override
    public boolean isValid(String mailList) {
        if (mailList==null||"".equals(mailList.trim())||mailList.length()>MAX_LENGTH) return false;
        boolean result = true;
        int space =0;
        String[] mails = mailList.split(SEPARATOR);
        try {
            for (String mail:mails) {
                if (mail == null || "".equals(mail.trim())) {
                    space++;
                    continue;
                }
                InternetAddress emailAddr = new InternetAddress(mail.trim());
                emailAddr.validate();
        }
        } catch (AddressException ex) {
            result = false;
        }
        if (mails.length==space) result= false;
        return result;
    }
}
