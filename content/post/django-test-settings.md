---
title: "Django Test Settings"
date: "2012-03-19T00:00:00-06:00"
featureimage: ""
menu: ""
tags: []

---

Recently I was setting up [Sentry logging][0] for an app I was working on, and
needed to turn it off for tests, as it was sending logs to a remote
server. Here's how I ended up doing that:

[0]: http://sentry.readthedocs.org/

<!--more-->

    import sys
        
    LOGGING = {
        'version': 1,
        'disable_existing_loggers': True,
        'root': {
            'level': 'WARNING',
            'handlers': ['sentry'],
        },
        # ... snip formatters ...
        'handlers': {
            'sentry': {
                'level': 'DEBUG',
                'class': 'raven.contrib.django.handlers.SentryHandler',
                'formatter': 'verbose',
            },
            'console': {
                'level': 'DEBUG',
                'class': 'logging.StreamHandler',
                'formatter': 'verbose',
            },
        },
        # ... snip loggers ...
    }

    if 'test' in sys.argv:
        # redirect default errors to NullHandler
        LOGGING['root']['handlers'] = ['console']
        LOGGING['handlers']['console']['class'] = 'logging.NullHandler'

Now I don't get logging messages in my test output when tests pass, and
the tests don't spam the logging server with messages.
