"""Servidor estático sem cache (Cache-Control: no-store) para testar o The-One-System sem versões velhas dos scripts."""
import http.server, sys, functools

class SemCache(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store, max-age=0')
        super().end_headers()

porta = int(sys.argv[1]); pasta = sys.argv[2]
http.server.ThreadingHTTPServer(('127.0.0.1', porta), functools.partial(SemCache, directory=pasta)).serve_forever()
