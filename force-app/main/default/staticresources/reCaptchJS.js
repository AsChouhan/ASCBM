<script runat='server'>
    Platform.Load('core', '1');
    try {

        var g_recaptcha_response = Request.GetFormField("g-recaptcha-response");
        var secret = "{{ RECAPTCHA SECRET KEY }}";
        var payload = "secret=" + secret + "&response=" + g_recaptcha_response;
        var req = HTTP.Post('https://www.google.com/recaptcha/api/siteverify', 'application/x-www-form-urlencoded', payload);

        if (req.StatusCode == 200) {
            var resp = Platform.Function.ParseJSON(String(req.Response));
			if(!resp.success) throw "reCAPTCHA request returned an error";
        	if(resp.score < 0.5) throw "reCAPTCHA score is low, probably a SPAM";
        } else {
            throw "reCAPTCHA API error";
        }

        Write(Stringify(resp));

    } catch (error) {
        Write(Stringify({ status: "Error", message: error }));
    }
</script>