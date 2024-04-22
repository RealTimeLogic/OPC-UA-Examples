all : led_and_button.zip

LED_AND_BUTTON_FILES=$(shell ls led_and_button -A)
led_and_button.zip: led_and_button/.preload
	cd led_and_button && zip -r ../led_and_button.zip $(LED_AND_BUTTON_FILES)


clean:
	rm -f led_and_button.zip
