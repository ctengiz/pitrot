# -*- coding: utf-8 -*-

"""
Helper module for i18n translation functions.

Base source from : http://webpy.org/cookbook/runtime-language-switch

__author__ : Çağatay Tengiz
__date__   : 27.01.2016
"""

import gettext
import os

import bottle

__BASE_PATH__ = os.path.abspath(os.path.dirname(__file__))
localedir = '%s/locale' %__BASE_PATH__


# Object used to store all translations.
allTranslations = {}


def get_translations(lang="en_US"):
    # Init translation.
    if lang in allTranslations:
        translation = allTranslations[lang]
    elif lang is None:
        translation = gettext.NullTranslations()
    else:
        try:
            translation = gettext.translation(
                'messages',
                localedir,
                languages=[lang],
                codeset="UTF8"
            )
        except IOError:
            translation = gettext.NullTranslations()
    return translation


def load_translations(lang):
    """Return the translations for the locale."""
    lang = str(lang)
    translation = allTranslations.get(lang)
    if translation is None:
        translation = get_translations(lang)
        allTranslations[lang] = translation

        # Delete unused translations.
        """
        for lk in allTranslations.keys():
            if lk != lang:
                del allTranslations[lk]
        """
    return translation


def custom_gettext(string):
    """
    Translate a given string to the language of the application

    :param string:
    :return:
    """

    translation = None
    s = bottle.request.environ.get('beaker.session')
    if s:
        if 'lang' in s:
            translation = load_translations(s['lang'])

    if translation is None:
        return string
    return translation.gettext(string)

_ = custom_gettext


def get_langs():
    return {'tr-TR': _('Turkish'), 'en-US': _('English')}