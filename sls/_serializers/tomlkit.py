"""
    salt.serializers.tomlkit
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~

    Implements TOML serializer using tomlkit
    instead of the buggy toml module

"""

from salt.serializers import DeserializationError, SerializationError

try:
    from tomlkit import TOMLDocument, parser

    HAS_TOML = True
except ImportError:
    HAS_TOML = False


__all__ = ["deserialize", "serialize", "HAS_TOML"]


def deserialize(stream_or_string):
    """
    Deserialize from TOML into Python data structure.

    :param stream_or_string: toml stream or string to deserialize.
    :param options: options given to the python toml module.
    """

    try:
        s = ""
        if isinstance(stream_or_string, file):
            s = stream_or_string.read().decode("utf-8")

        if not isinstance(stream_or_string, (bytes, str)):
            s = stream_or_string.read().decode("utf-8")

        if isinstance(stream_or_string, bytes):
            s = stream_or_string.decode("utf-8")

        p = parser.parser(s)
        return p.parse()
    except Exception as error:  # pylint: disable=broad-except
        raise DeserializationError(error)


def serialize(obj, file_out=False):
    """
    Serialize Python data to TOML.

    :param obj: the data structure to serialize.
    :param file_out: file to output to, str of file
    """

    try:
        t = TOMLDocument()
        t.update(obj)
    except Exception as error:  # pylint: disable=broad-except
        raise SerializationError(error)

    if file_out:
        if isinstance(file_out, (bytes, str)):
            with open(options["file_out"], 'wb') as f:
                f.write(t.as_string())
            return True
        elif isinstance(file_out, file):
            file_out.write(t.as_string())
            return True
        else:
            raise SerializationError("Unknown file_out type:{0}".\
                                     format(file_out))
    else:
        return t.as_string()
