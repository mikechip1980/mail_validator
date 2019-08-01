import mail.SimpleTemplateValidator;
import mail.StandardInternetAddressValidator;
import mail.Validator;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import static mail.Validator.MAX_LENGTH;
import static mail.Validator.SEPARATOR;
import static org.junit.Assert.assertFalse;

public class ValidatorTest {

    private Validator validator;

    @Before
    public void init(){
       // validator= new SimpleTemplateValidator(); //change to desired implementation here
        validator= new StandardInternetAddressValidator();
    }

    @Test
    public void emptyString(){
        assertFalse(validator.isValid(""));
        assertFalse(validator.isValid(";;"));
    }
    @Test
    public void tooLongString(){
        StringBuilder str=new StringBuilder("mchapleev@gmail.com");
        while (str.length()<=MAX_LENGTH)
            str.append(SEPARATOR).append(str);
          assertFalse(validator.isValid(str.toString()));
    }

    private void batchAssertTrue(String[] cases){
        for (String cs:cases){
            Assert.assertTrue(": Wrong value:"+cs,validator.isValid(cs));
        }
    }

    private void batchAssertFalse(String[] cases){
        for (String cs:cases){
            Assert.assertFalse(": Wrong value:"+cs,validator.isValid(cs));
        }
    }

    @Test
    public void differentSeparatorLocationCorrect(){
        String[] variants={"mchapleev@gmail.com;mpetrov@gmail.com",
                            "mchapleev@gmail.com;mpetrov@gmail.com;",
                            "mchapleev@gmail.com;",
                            "mchapleev@gmail.com;;",
                            ";mchapleev@gmail.com;;",
                            ";mchapleev@gmail.com",
                            };
        batchAssertTrue(variants);
    }



    @Test
    public void wrongSeparator(){
        String[] variants={"mchapleev@gmail.com,mpetrov@gmail.com",
                "mchapleev@gmail.com,mpetrov@gmail.com;",
                "mchapleev@gmail.com,",
                ",mchapleev@gmail.com,,"
        };
        batchAssertFalse(variants);
    }

    @Test
    public void underscore(){
        String[] variants={"mikhail_chapleev@gmail.com;mpetrov@gmail.com",
                "mchapleev@gmail.com;maxim_petrov@gmail.com",
                "mikhail_chapleev@gmail.com"
        };
        batchAssertTrue(variants);
    }

    @Test
    public void dot(){
        String[] variants={"mikhail.chapleev@gmail.com;mpetrov@gmail.com",
                "mchapleev@gmail.com;maxim.petrov@gmail.com",
                "mikhail.chapleev@gmail.com"
        };
        batchAssertTrue(variants);
    }

    @Test
    public void cirillic(){
        String[] variants={"михаил@gmail.com;mpetrov@gmail.com",
                "mchapleev@gmail.com;максим@gmail.com",
                "михаил@gmail.com",
                "mchapleev@мэйл.com"
        };
        batchAssertFalse(variants);
    }

    @Test
    public void domain(){
        String[] variants={"mchapleev@gmail.c","mchapleev@.com","mchapleev@gmail.1m"};
        batchAssertFalse(variants);
    }

    @Test
    public void validMail(){
        String[] variants={"mchapleev@gmail.com","mchapleev1980-1@mail.ru","mchapleev@gmail.com.ru","mchapleev@25.com","mchapleev@25-test.com"};
        batchAssertTrue(variants);
    }

    @Test
    public void at(){
        String[] variants={"mchapleevgmail.com","mchapleev@@gmail.com","mikhail@chapleev@gmail.com"};
        batchAssertFalse(variants);
    }

    @Test
    public void specialSymbols(){
        String[] variants={"m{}chapleev@@gmail.com","mikhail@chapleev@gmail.com","mikhail chapleev@gmail.com"};
        batchAssertFalse(variants);
    }

    @Test
    public void spacesCorrect(){
        String[] variants={" mchapleev@@gmail.com","mikhail@chapleev@gmail.com "," mikhail@chapleev@gmail.com "
                                ," mikhail@chapleev@gmail.com ; mpetrov@gmail.com "};
        batchAssertFalse(variants);
    }

    @Test
    public void startIncorrect(){
        String[] variants={"mchapleev@@gmail.com","mikhail@chapleev@gmail.com "," mikhail@chapleev@gmail.com "
                ," mikhail@chapleev@gmail.com ; mpetrov@gmail.com "};
        batchAssertFalse(variants);
    }

}
