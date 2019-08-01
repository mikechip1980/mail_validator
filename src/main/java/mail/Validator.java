package mail;

public interface Validator {
    String SEPARATOR=";";
    int MAX_LENGTH=1024;
    boolean isValid(String mailList);
}
