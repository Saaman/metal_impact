var I18n = I18n || {};
I18n.translations = {"en":{"activerecord":{"errors":{"messages":{"taken":"has already been taken","record_invalid":"Validation failed: %{errors}","invalid_enum":"invalid option supplied."},"models":{"user":{"attributes":{"email":{"invalid":"must be a valid e-mail address"},"email_confirmation":{"custom_confirmation":"E-mail and confirmation don't match"},"password":{"too_short":"is too short (at least 6 characters)","invalid":"must contain at least one character that is not a letter"},"pseudo":{"taken":"This user name is already taken. Please choose another one","too_short":"is too short (at least 4 characters)"}}}}},"attributes":{"user":{"email":"e-mail","email_confirmation":"e-mail confirmation"}},"enums":{"user":{"genders":{"male":"Male","female":"Female"}}}}},"fr":{"activerecord":{"errors":{"format":"Le %{attribute} %{message}","messages":{"accepted":"doit \u00eatre accept\u00e9(e)","blank":"doit \u00eatre rempli(e)","confirmation":"ne concorde pas avec la confirmation","empty":"doit \u00eatre rempli(e)","equal_to":"doit \u00eatre \u00e9gal \u00e0 %{count}","even":"doit \u00eatre pair","exclusion":"n'est pas disponible","greater_than":"doit \u00eatre sup\u00e9rieur \u00e0 %{count}","greater_than_or_equal_to":"doit \u00eatre sup\u00e9rieur ou \u00e9gal \u00e0 %{count}","inclusion":"n'est pas inclus(e) dans la liste","invalid":"n'est pas valide","less_than":"doit \u00eatre inf\u00e9rieur \u00e0 %{count}","less_than_or_equal_to":"doit \u00eatre inf\u00e9rieur ou \u00e9gal \u00e0 %{count}","not_a_number":"n'est pas un nombre","not_an_integer":"doit \u00eatre un nombre entier","odd":"doit \u00eatre impair","record_invalid":"La validation a \u00e9chou\u00e9 : %{errors}","taken":"n'est pas disponible","too_long":{"one":"est trop long (pas plus de %{count} caract\u00e8re)","other":"est trop long (pas plus de %{count} caract\u00e8res)"},"too_short":{"one":"est trop court (au moins %{count} caract\u00e8re)","other":"est trop court (au moins %{count} caract\u00e8res)"},"wrong_length":{"one":"ne fait pas la bonne longueur (doit comporter %{count} caract\u00e8re)","other":"ne fait pas la bonne longueur (doit comporter %{count} caract\u00e8res)"}},"template":{"body":"Veuillez v\u00e9rifier les champs suivants\u00a0: ","header":{"one":"Impossible d'enregistrer ce(tte) %{model} : %{count} erreur","other":"Impossible d'enregistrer ce(tte) %{model} : %{count} erreurs"}},"models":{"user":{"attributes":{"email":{"invalid":"doit \u00eatre une adresse e-mail valide"},"email_confirmation":{"custom_confirmation":"L'e-mail et la confirmation ne concordent pas"},"password":{"too_short":"est trop court (au moins 6 caract\u00e8res)","invalid":"doit contenir au moins un caract\u00e8re qui n'est pas une lettre"},"pseudo":{"taken":"Ce pseudo est d\u00e9j\u00e0 utilis\u00e9. Merci d'en choisir un autre","too_short":"est trop court (au moins 4 caract\u00e8res)"}}}}},"attributes":{"user":{"email":"e-mail","email_confirmation":"confirmation d'e-mail"}},"enums":{"user":{"genders":{"male":"Homme","female":"Femme"}}}}}};