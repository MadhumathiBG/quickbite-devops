from http.server import BaseHTTPRequestHandler, HTTPServer
import json

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/api":
            response = {
                "platform": "QuickBite",
                "message": "Dummy backend is running",
                "status": "success"
            }

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(response).encode())
        else:
            self.send_response(404)
            self.end_headers()

server = HTTPServer(("0.0.0.0", 5000), Handler)
print("QuickBite backend running on port 5000")
server.serve_forever()
