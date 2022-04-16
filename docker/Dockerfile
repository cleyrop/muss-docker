ARG baseref="cleyrop/codatalab-muss-base"
ARG version="0.0.1"
ARG modelen="cleyrop/codatalab-muss-model-en"
ARG modeles="cleyrop/codatalab-muss-model-es"
ARG modelfr="cleyrop/codatalab-muss-model-fr"

FROM $modelen:$version as EN
FROM $modeles:$version as ES
FROM $modelfr:$version as FR

FROM $baseref:$version AS base

COPY --from=EN /home/codatalab/.local/lib/python3.7/site-packages/en_core_web_md /home/codatalab/.local/lib/python3.7/site-packages/en_core_web_md
COPY --from=EN /home/codatalab/.local/lib/python3.7/site-packages/en_core_web_md-2.3.1.dist-info /home/codatalab/.local/lib/python3.7/site-packages/en_core_web_md-2.3.1.dist-info

COPY --from=ES /home/codatalab/.local/lib/python3.7/site-packages/es_core_news_md /home/codatalab/.local/lib/python3.7/site-packages/es_core_news_md
COPY --from=ES /home/codatalab/.local/lib/python3.7/site-packages/es_core_news_md-2.3.1.dist-info /home/codatalab/.local/lib/python3.7/site-packages/es_core_news_md-2.3.1.dist-info

COPY --from=FR /home/codatalab/.local/lib/python3.7/site-packages/fr_core_news_md /home/codatalab/.local/lib/python3.7/site-packages/fr_core_news_md
COPY --from=FR /home/codatalab/.local/lib/python3.7/site-packages/fr_core_news_md-2.3.0.dist-info /home/codatalab/.local/lib/python3.7/site-packages/fr_core_news_md-2.3.0.dist-info

#RUN chown -R codatalab /home/codatalab

EXPOSE 22
COPY resources/entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD tail -f /dev/null