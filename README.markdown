# Quentin

## Quick entry mode for reminders using Launch Center Pro

I like the built in Reminder application on iOS and Mac OS X. Sadly the *unofficial* URL schemes for creating new reminders had to be removed from Launch Center Pro. Since LCP lacks native reminders like Drafts, this application is designed to fill the gap. 

Just open it once to allow the reminder access. 

The app supports `x-callback` ([read more](http://x-callback-url.com/))

## Example

Adding a new reminder in the default Reminder list using the current clipboard for the notes field and returning to Launch Center Pro:

	quentin://x-callback-url/newReminder?x-success=launch://&x-source=Launch%20Center%20Pro&name=[prompt]&notes=[clipboard]
	
Adding a new reminder to a specific list using the current clipboard for the notes field and returning to Launch Center Pro:

	quentin://x-callback-url/newReminder?x-success=launch://&x-source=Launch%20Center%20Pro&name=[prompt]&notes=[clipboard]&list=[prompt]
	
	
## TODO

- Remind me on date
- Remind me on location
- Priority
- Help screen to simply copy URL schemes
- App Icon