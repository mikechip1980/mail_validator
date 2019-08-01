package mail;

import java.util.regex.Pattern;

public class SimpleTemplateValidator implements  Validator {
    private static final String PATTERN =
            "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*(\\.[A-Za-z]{2,})$";

    public SimpleTemplateValidator() {
        pattern = Pattern.compile(PATTERN);
    }

    private Pattern pattern;

    public boolean isValid(String mailList) {
        if (mailList==null||"".equals(mailList.trim())||mailList.length()>MAX_LENGTH) return false;
        String[] mails = mailList.split(SEPARATOR);
        int space =0;
        for (String mail : mails) {
            if (mail == null || "".equals(mail.trim())) {
                space++;
                continue;
            }
            if (!pattern.matcher(mail.trim()).matches()) return false;
        }
        if (mails.length==space) return false;
        return true;

    }
}
