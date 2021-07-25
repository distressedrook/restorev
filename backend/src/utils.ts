export function wrapSuccess(body: any): any {
  return {
    success: {
      data: body,
    },
  };
}

export function wrapError(err: any[]): any {
  return {
    errors: err,
  };
}
