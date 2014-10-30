import requests
import time

username="random.org"
channel="#random"

payload={"channel": channel,
         "username": username,
         "text": ""}
slack_url="https://jive.slack.com/services/hooks/incoming-webhook?token={token}"


def random_wiki_article():
    url ="http://en.wikipedia.org/wiki/Special:Random"
    r = requests.get(url)
    if r.status_code == 200:
        return r.url
    return None


def random_org(min=1, max=100):
    params = {"num": 1,
               "min": min,
               "max": max,
               "col": 1,
               "base": 10,
               "format": "plain",
               "rnd": "new"
    }
    r = requests.get("http://random.org/integers/", params=params)
    if r.status_code == 200:
        return r.text.replace("\n", "")
    return None

def slack_webhook():
    pass



def main():
    r = random_org(1, 2)
    message_generators = {"1": random_org,
                          "2": random_wiki_article}
    print r
    gen = message_generators.get(r)

    return gen()


if __name__ == "__main__":
    main()
